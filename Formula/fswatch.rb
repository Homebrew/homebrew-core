class Fswatch < Formula
  desc "Monitor a directory for changes and run a shell command"
  homepage "https://github.com/emcrisostomo/fswatch"
  url "https://github.com/emcrisostomo/fswatch/releases/download/1.10.0/fswatch-1.10.0.tar.gz"
  sha256 "f0b35bcc27e73dbeeb2e74567f978e11b239a2ea229f870ce27b39593ab0eb72"

  bottle do
    cellar :any
    sha256 "45de7e8a404f7b7934dc76cd025fae7ac4555a3b8e96e853428fb028d5d80c9b" => :sierra
    sha256 "5ce97f3f7a50762c5c105f9eb554145fa18811cea4868087f78d52eeb1318011" => :el_capitan
    sha256 "bc873f329954ca845e42850d4bb89f98445eb20b91b6f4a28e6f9d891387b1e4" => :yosemite
    sha256 "2cf399f573a47f40efcff0c686f3b3b78381c7cb7da4aa82b9d61d018358ce67" => :mavericks
  end

  needs :cxx11

  def install
    ENV.cxx11
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system bin/"fswatch", "-h"
  end
end
