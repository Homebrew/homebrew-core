class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-18.0.1.tgz"
  sha256 "234071a268c0647a1b7fc5a97266364c5f76c870a5b00542949964c239f3da1d"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "991008a037564fb670fab041508ef57c90e6c17c548289aca299b77763700361"
    sha256                               arm64_sonoma:  "e84d37a8a634a043d68f42b459b37bf60a49bb717bd7e60798042fe71bc21d2b"
    sha256                               arm64_ventura: "398cc9eb1125278855711f0e33f5229bb6842ed6ece93c5c62eac1b0ace59232"
    sha256                               sonoma:        "8477fc666932d8801fdfa1767e3441ac022d2cd9c1114e928d5a4fdeafef8b3e"
    sha256                               ventura:       "df9930e385e398b863a442861ed75fccc8cf11d3eea9edb4785f7a923a76c551"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66d9e42dc4f170fb76b83acc89bfffe63197c6afe54357627b820922a98697da"
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
