class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-19.1.1.tgz"
  sha256 "d00a3fb62964e7b9525d925dce4019e6bc862254db1eb13285f9f134e4336797"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "043c3b6f4709fe93cf826c69f756a3e6ab9b5715f64fffa1f611fb34bc15d4fb"
    sha256                               arm64_sonoma:  "09a169c2b548df28d1dc5d4c3873b62c4686fc24a2a4f39e2dda8a772e79c6be"
    sha256                               arm64_ventura: "466967f08530358219e171a79a296d6155621fca96ab82409a4667d6c3795b8c"
    sha256                               sonoma:        "cd0a8609562050a0d1fcb924f73da462982e9e22d7afe7ef761f255abd3b806c"
    sha256                               ventura:       "3c3bcf39e40e42e45f68c713877155b2eab59d0bf13e2d7f6b36aeb23c91e5a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3429042c12411fc114b1dcb748336aa79ed2ad49af204f8b2000432daf16066"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4674a56e235fe1e3138697ac60a9f817249cf46a122f3971dc889ed3f30dac11"
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
