require "language/node"

class Fanyi < Formula
  desc "Mandarin and english translate tool in your command-line"
  homepage "https://github.com/afc163/fanyi"
  url "https://registry.npmjs.org/fanyi/-/fanyi-5.1.1.tgz"
  sha256 "38ddf5d2e06007e915257ecd7f7e939e033c44a2060a1f13d4e5f41f60e3ab1e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b79858ee2720463b8165a60cecf7544dbfbb64a92d7af18dec4526fc69b905c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bdb5e4c6f216c41688c1e6935433006195eab8846bed9024a332537e73ca2dd6"
    sha256 cellar: :any_skip_relocation, monterey:       "2ed67703f3155a7807dcb2c3247fb6e4b81fb154c7c19f3c04a8f5ea83727407"
    sha256 cellar: :any_skip_relocation, big_sur:        "5548268ec8a85f156de8612bdd8e236d7495fc8e5e3f7f9c96e05b4d54305eff"
    sha256 cellar: :any_skip_relocation, catalina:       "5548268ec8a85f156de8612bdd8e236d7495fc8e5e3f7f9c96e05b4d54305eff"
    sha256 cellar: :any_skip_relocation, mojave:         "5548268ec8a85f156de8612bdd8e236d7495fc8e5e3f7f9c96e05b4d54305eff"
  end

  depends_on "node"

  on_macos do
    depends_on "macos-term-size"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir[libexec/"bin/*"]

    term_size_vendor_dir = libexec/"lib/node_modules"/name/"node_modules/term-size/vendor"
    term_size_vendor_dir.rmtree # remove pre-built binaries

    if OS.mac?
      macos_dir = term_size_vendor_dir/"macos"
      macos_dir.mkpath
      # Replace the vendored pre-built term-size with one we build ourselves
      ln_sf (Formula["macos-term-size"].opt_bin/"term-size").relative_path_from(macos_dir), macos_dir
    end
  end

  test do
    assert_match "爱", shell_output("#{bin}/fanyi lov 2>/dev/null")
  end
end
