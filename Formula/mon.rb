class Mon < Formula
  desc "Monitor hosts/services/whatever and alert about problems"
  homepage "https://github.com/visionmedia/mon"
  url "https://github.com/visionmedia/mon/archive/1.2.3.tar.gz"
  sha256 "978711a1d37ede3fc5a05c778a2365ee234b196a44b6c0c69078a6c459e686ac"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ac4640eab6cb255b7cc14f7009b5e8c5a18f9b623559950a1e6d55eb134d483e" => :mojave
    sha256 "66fe59cb8307fd1371885fe1739a824d01becb1644a8480f8e27584726494f09" => :high_sierra
    sha256 "0d22815460538deda7a6a979d0b7dcdf38124ed9473764f6a90d8252cb9bf1aa" => :sierra
    sha256 "4f2d05a85fac75167df3a445a0803f7d5eddb2bacf967b10738db5066955024a" => :el_capitan
    sha256 "b446ffbcff634978ff036de6b5585d29e11a6b38604fa78268c7717819250a0f" => :mavericks
  end

  def install
    bin.mkpath
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"mon", "-V"
  end
end
