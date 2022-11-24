require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  # gatsby-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-5.1.0.tgz"
  sha256 "4870a6a3e1b3c4b906dd59f34cfbaa9b37ff5952e4cd15b57aea3b0a1a9cdf83"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "80011aeaab2bfa0b6e0fb3e507c8925e2cbfb9928c8b0b19c305b9d0b60fb95b"
    sha256                               arm64_monterey: "06b8f9f52ae044cf7a21df4ece6e7d59c9f742ffaab566dc808946b1e10ce12c"
    sha256                               arm64_big_sur:  "cd4081ee6d2a2b3b327d2309b448e1368b544f081a7bfa057929bc9a8f4cba2d"
    sha256                               ventura:        "33c8c043a189148f333cd8bc5cb00b74435a87896d4baea1d728debdbef081a1"
    sha256                               monterey:       "d06a93f6751afc038366d622770929026e0c4e37182f5b72b475df6a4c9d52a1"
    sha256                               big_sur:        "645c134290a178ff44ad76349c2a714f6518b8cc3123295d223268b38c8384b9"
    sha256                               catalina:       "215e302dd62e1c8adb7fa4ededc98a3c114e40c805b486c6c3ac49a1da350168"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7994cbcaa7297d7737541509759ec3a62a80ea068822649e81273205441afb10"
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
