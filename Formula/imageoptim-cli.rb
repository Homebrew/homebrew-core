require "language/node"

class ImageoptimCli < Formula
  desc "CLI for ImageOptim, ImageAlpha and JPEGmini"
  homepage "https://jamiemason.github.io/ImageOptim-CLI/"
  url "https://github.com/JamieMason/ImageOptim-CLI/archive/2.0.3.tar.gz"
  sha256 "47fc8a1f14478389cb71dc8a03ac6b3176ba311d1a2390867b792b60ef209fb3"

  bottle do
    cellar :any_skip_relocation
    sha256 "4e2ecb52446d8a0cdf464189d1bc5900cf06b132b7964638b70732c43c4b9e9f" => :high_sierra
    sha256 "4e2ecb52446d8a0cdf464189d1bc5900cf06b132b7964638b70732c43c4b9e9f" => :sierra
    sha256 "4e2ecb52446d8a0cdf464189d1bc5900cf06b132b7964638b70732c43c4b9e9f" => :el_capitan
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
