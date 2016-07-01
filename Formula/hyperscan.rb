class Hyperscan < Formula
  desc "High-performance regular expression matching library"
  homepage "https://01.org/hyperscan"
  url "https://github.com/01org/hyperscan/archive/v4.2.0.tar.gz"
  sha256 "d06d8f31a62e5d2903a8ccf07696e02cadf4de2024dc3b558d410d913c81dbef"

  bottle do
    cellar :any_skip_relocation
    sha256 "2b329383f8299ac45263713545c087dcc1182a8e3d665ea41500799e0c88ce90" => :el_capitan
    sha256 "f0e8559d67e926c9afaed0ea037d70643073673f027c21817679a2ca26fd4827" => :yosemite
    sha256 "13c9cb6d0aa29dd4039148a7ac06a6dadc9c89d72ff5b2fa42a29d1d3833fd32" => :mavericks
  end

  depends_on :python => :build if MacOS.version <= :snow_leopard
  depends_on "boost" => :build
  depends_on "ragel" => :build
  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <stdio.h>
      #include <hs/hs.h>
      int main()
      {
        printf("hyperscan v%s", hs_version());
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lhs", "-o", "test"
    system "./test"
  end
end
