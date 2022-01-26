require "language/node"

class ImageoptimCli < Formula
  desc "CLI for ImageOptim, ImageAlpha and JPEGmini"
  homepage "https://jamiemason.github.io/ImageOptim-CLI/"
  url "https://github.com/JamieMason/ImageOptim-CLI/archive/3.0.7.tar.gz"
  sha256 "ed1a36ccb0e960152eda6b3d4c422ee355c8cf8271f1f8e71141a286c4d647e5"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, monterey:    "fec70bca8360bb34c5f5758da13615cc5c833dceb4559a71ee62223b0684c73b"
    sha256 cellar: :any_skip_relocation, big_sur:     "fd8ea02974a34708556c132b2258c12d68e379abfd1f0e591d193f97489d03fb"
    sha256 cellar: :any_skip_relocation, catalina:    "56a9b2dba8f47850a26c335311f8c436b683c0b92ef5ab0b83e91688cf64ec7a"
    sha256 cellar: :any_skip_relocation, mojave:      "b7b1923ed31ab32540a5dffcf798675401ca48249fae54f49d67bc6c78feede9"
    sha256 cellar: :any_skip_relocation, high_sierra: "6f1aa4b2e4de3e7a1502f1f8747283589697e5f0f0506f4d24acd53381311706"
  end

  depends_on "node" => :build
  depends_on "yarn" => :build
  depends_on arch: :x86_64 # Installs pre-built x86-64 binaries
  depends_on :macos

  def install
    Language::Node.setup_npm_environment
    system "yarn"
    system "npm", "run", "build"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/imageoptim -V").chomp
  end
end
