require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  # gatsby-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-4.11.0.tgz"
  sha256 "cd4d8d680e666af8099eb8dddc99fac4159abfcd0a448a8a1991e30a1378eb52"
  license "MIT"

  bottle do
    sha256                               arm64_monterey: "031cccc1650b42fd06181a34374c10ef73ccf6dd7926c35f7dea32549f1ca4cf"
    sha256                               arm64_big_sur:  "88505318e33820011f96e07ab330a0d7e0aefa912119b34ac859d04880bcd87c"
    sha256                               monterey:       "ca47b0628628425f29902553be3c67b952042a76263b46a7e1915f1db2baa162"
    sha256                               big_sur:        "4cf0ef15d1bf8a3811817a2629f7a2cbea14f472d27747ba5c6c5a0ec72b8f71"
    sha256                               catalina:       "513bbf80c42857ce679e06f5c6b42f1ca63742fd11e4629406b322021976d13f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "207600cbf013d2c8d93e298e6f023ec4f33713fc12c167b8ec8a79673fce5ea8"
  end

  depends_on "node"

  on_macos do
    depends_on "macos-term-size"
  end

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir[libexec/"bin/*"]

    # Avoid references to Homebrew shims
    node_modules = libexec/"lib/node_modules/#{name}/node_modules"
    rm_f node_modules/"websocket/builderror.log"

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{lmdb,msgpackr-extract}/prebuilds/*").each do |dir|
      if dir.basename.to_s != "#{os}-#{arch}"
        dir.rmtree
      elsif OS.linux?
        dir.glob("*.musl.node").map(&:unlink)
      end
    end

    term_size_vendor_dir = node_modules/"term-size/vendor"
    term_size_vendor_dir.rmtree # remove pre-built binaries
    if OS.mac?
      macos_dir = term_size_vendor_dir/"macos"
      macos_dir.mkpath
      # Replace the vendored pre-built term-size with one we build ourselves
      ln_sf (Formula["macos-term-size"].opt_bin/"term-size").relative_path_from(macos_dir), macos_dir
    end

    clipboardy_fallbacks_dir = node_modules/"clipboardy/fallbacks"
    clipboardy_fallbacks_dir.rmtree # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin/"xsel").relative_path_from(linux_dir), linux_dir
    end
  end

  test do
    system bin/"gatsby", "new", "hello-world", "https://github.com/gatsbyjs/gatsby-starter-hello-world"
    assert_predicate testpath/"hello-world/package.json", :exist?, "package.json was not cloned"
  end
end
