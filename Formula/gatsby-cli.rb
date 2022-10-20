require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  # gatsby-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-4.24.0.tgz"
  sha256 "1921be8b0f9fe13ff7ad2e5e731ecd00782de7a062edcbe8ae77082305469ac5"
  license "MIT"

  bottle do
    sha256                               arm64_monterey: "b346a5431f723cf05dc49ee2a790fcdf5bab7def5855d92b30662203b1225ab7"
    sha256                               arm64_big_sur:  "100c4e8d41d3ed3e9511f08bfed41d857931b530f48dc09baa730e75a2967f12"
    sha256                               monterey:       "d67970714d1aab52db62afd7bdf448da5633b3ec3a21426d988258b8bff24c06"
    sha256                               big_sur:        "072fbb53697bdcde145d18944b57401cdc45090e74cb90cad9efec4c538ec4f3"
    sha256                               catalina:       "b53fe5cf35f3540ea3dfb83c5e66fc276195eee749e97e834e0a1bf26036327a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36d282e1ae478cb996948eb500ff6cdfb6928155305fb473397436e850582304"
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

    # Remove incompatible pre-built binaries
    node_modules = libexec/"lib/node_modules/#{name}/node_modules"
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    if OS.linux?
      %w[@lmdb/lmdb @msgpackr-extract/msgpackr-extract].each do |mod|
        node_modules.glob("#{mod}-linux-#{arch}/*.musl.node")
                    .map(&:unlink)
                    .empty? && raise("Unable to find #{mod} musl library to delete.")
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
