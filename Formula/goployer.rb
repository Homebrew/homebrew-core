class Goployer < Formula
  desc "AWS Deployer with Go"
  homepage "https://goployer.dev"
  url "https://github.com/DevopsArtFactory/goployer/archive/1.0.1.tar.gz"
  sha256 "70a37a85a1a18ea10c6522ae9b29d38462625bb14720cd6fd35b8c95c8fdb955"
  license "Apache-2.0"
  head "https://github.com/DevopsArtFactory/goployer.git"

  depends_on "go" => :build

  def install
    system "make"
    bin.install "out/goployer"
  end

  test do
    system "true"
  end
end
