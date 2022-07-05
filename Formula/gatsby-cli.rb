require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  # gatsby-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-4.18.0.tgz"
  sha256 "64a97fef347a5fa05e7bdc239271083d31bd26c0eb47bb8381f821b06292c083"
  license "MIT"

  bottle do
    sha256                               arm64_monterey: "94e30f548bca855bc8528afa63285da3d7ba9ade367ba3bb9c8cebe25b4ad0af"
    sha256                               arm64_big_sur:  "fbb7392d8cb884d7e3bd3770a970656a85f04c4790d24e9f7e5117dbbed19507"
    sha256                               monterey:       "4216ad9f9ba0c5b7de63db82371f83eb7e8cfe6d127c2dd53c7a1da79cfad07c"
    sha256                               big_sur:        "ec64584ab57bc5375e2346b3edbbcc31b6521e410c2603659be8c40b21654c5d"
    sha256                               catalina:       "8fc61067c79603e6139bb924144d48d1bec483a1d6029740d26516154f32c21b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9cff5a45524c4a8ab78c90574e918b403140347dfb63d579f948b2b46e74dccf"
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
