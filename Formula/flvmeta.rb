class Flvmeta < Formula
  desc "Manipulate Adobe flash video files (FLV)"
  homepage "https://www.flvmeta.com/"
  url "https://github.com/noirotm/flvmeta/archive/v1.1.2.tar.gz"
  sha256 "ee98c61e08b997b96d9ca4ea20ee9cff2047d8875d09c743d97b1b1cc7b28d13"

  bottle do
    cellar :any_skip_relocation
    sha256 "d33edf6ae455b22f4f0d4dff4a74de544327aca4c664b46312f2c25c02a26b5d" => :el_capitan
    sha256 "bc6967dd66ec323eae27e2d63a7ae87850a6c3f5385ac15753e664220e31ce3b" => :yosemite
    sha256 "ba027c8f1b18eec093938926101769676fc86bbaff1580929679e46b8fa21099" => :mavericks
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/flvmeta", "-V"
  end
end
