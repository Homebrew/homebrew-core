class Libpagemaker < Formula
  desc "Imports file format of Aldus/Adobe PageMaker documents"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libpagemaker"
  url "https://dev-www.libreoffice.org/src/libpagemaker/libpagemaker-0.0.4.tar.xz"
  sha256 "66adacd705a7d19895e08eac46d1e851332adf2e736c566bef1164e7a442519d"

  bottle do
    cellar :any
    sha256 "1007bfa6a41111c5e1145dfb6e8a587364d9ab135ed06b12d8dba5bad7cc591c" => :high_sierra
    sha256 "1040a0447789ec70fd571c064981c07802c047b165ce7ab2a8513c424ac5e1f0" => :sierra
    sha256 "7e5ea731ac98d5efb7195a103d00f5a2ee24a229226da45db768c4c9cfaa57cc" => :el_capitan
    sha256 "62d0b098767d5175d5a30a3403b15a2e0226b8947a6c16d27803231eb72ff87c" => :yosemite
    sha256 "101fb46a0173340ee32c7ea52f7d583003ff568a422395b07bb2c864f5160602" => :mavericks
  end

  depends_on "boost" => :build
  depends_on "pkg-config" => :build
  depends_on "librevenge"

  def install
    system "./configure", "--without-docs",
                          "--disable-dependency-tracking",
                          "--enable-static=no",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <libpagemaker/libpagemaker.h>
      int main() {
        libpagemaker::PMDocument::isSupported(0);
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test",
                    "-I#{Formula["librevenge"].include}/librevenge-0.0",
                    "-I#{include}/libpagemaker-0.0",
                    "-L#{Formula["librevenge"].lib}",
                    "-L#{lib}",
                    "-lrevenge-0.0",
                    "-lpagemaker-0.0"
    system "./test"
  end
end
