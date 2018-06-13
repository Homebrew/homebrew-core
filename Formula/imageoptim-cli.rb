require "language/node"

class ImageoptimCli < Formula
  desc "CLI for ImageOptim, ImageAlpha and JPEGmini"
  homepage "https://jamiemason.github.io/ImageOptim-CLI/"
  url "https://github.com/JamieMason/ImageOptim-CLI/archive/2.0.3.tar.gz"
  sha256 "47fc8a1f14478389cb71dc8a03ac6b3176ba311d1a2390867b792b60ef209fb3"

  bottle do
    cellar :any_skip_relocation
    sha256 "fda19a2e3f525c96fa8b08ebb35fd6ab8bf361d40e5cd76f5b585d725b6f813e" => :high_sierra
    sha256 "fda19a2e3f525c96fa8b08ebb35fd6ab8bf361d40e5cd76f5b585d725b6f813e" => :sierra
    sha256 "fda19a2e3f525c96fa8b08ebb35fd6ab8bf361d40e5cd76f5b585d725b6f813e" => :el_capitan
  end

  depends_on "node" => :build

  def install
    system "npm", "install", *Language::Node.local_npm_install_args
    system "npm", "run-script", "build"
    libexec.install "dist", "osascript"
    bin.install_symlink libexec/"dist/imageoptim"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/imageoptim -V").chomp
  end
end
