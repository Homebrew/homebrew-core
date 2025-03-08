class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-19.0.2.tgz"
  sha256 "c2085f87b9533ed42735bc91d6b0c37872c6d4a4dc5c89801e9d9a914cf67c7a"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "51e5057d35953a1b4714ca84c33ff0132be91c78e32dbbff0a5232ab66666fb9"
    sha256                               arm64_sonoma:  "a443ed892c250d97e10405226c3db33cfde3dc00198834af2a84f12c8b9874aa"
    sha256                               arm64_ventura: "d594e277574d79d3a37b6ac402534b2559a76e975351a9e318868f2ef6c958af"
    sha256                               sonoma:        "6771b137ab5021c0acd92f3052053f14611d9c51081373d792a36054149f670b"
    sha256                               ventura:       "99d68ca9c2ccc9edfa7e41073580a3339d1251d11d882e68b5630e0d8d969cd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "570f595cf14e3dc6813fe91e99dd4a0c1cec8a0944e3c2aecfd26594b34845cb"
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
