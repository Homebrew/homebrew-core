class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-20.0.0.tgz"
  sha256 "67b878ac8de78bb326d44e2020e1c2bd3ddaf7025ca64a7a79b83447534df03b"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "a3c329f87751e5fc5d93bb7c9abf600d9f33785fcdc38d032341a44009f5747b"
    sha256                               arm64_sonoma:  "d2fdda57fa8b75a53a1300ebbe03d17a745efb0b0999a76ed3ca874d8a275bc2"
    sha256                               arm64_ventura: "181d5d7199058ba50ef14af57f142cc2507d4acdbf18b41c2efaec6c05012a4a"
    sha256                               sonoma:        "fcc3607cf327f7933fe159795363c4c99aa63d184104aa539b7b9c7af304a699"
    sha256                               ventura:       "73c77a620267c916a3768f31af1919eeb5aed2bdd445dc502bb3839b98eed518"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3478d185343eabf1a0151cf27a231574067472146304dd356e513ec89178e6f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a03b95a291e65e3577e51ad539c7113ce4af5d11fe0ee3666268f876a2a89d2a"
  end

  depends_on "node"

  on_linux do
    depends_on "glib"
    depends_on "gmp"
    depends_on "vips"
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    node_modules = libexec/"lib/node_modules/netlify-cli/node_modules"

    if OS.linux?
      (node_modules/"@lmdb/lmdb-linux-x64").glob("*.musl.node").map(&:unlink)
      (node_modules/"@msgpackr-extract/msgpackr-extract-linux-x64").glob("*.musl.node").map(&:unlink)
    end

    clipboardy_fallbacks_dir = node_modules/"clipboardy/fallbacks"
    rm_r(clipboardy_fallbacks_dir) # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin/"xsel").relative_path_from(linux_dir), linux_dir
    end

    # Remove incompatible pre-built `bare-fs`/`bare-os` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match "Not logged in. Please log in to see site status.", shell_output("#{bin}/netlify status")
  end
end
