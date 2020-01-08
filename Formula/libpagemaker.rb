class Libpagemaker < Formula
  desc "Imports file format of Aldus/Adobe PageMaker documents"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libpagemaker"
  url "https://dev-www.libreoffice.org/src/libpagemaker/libpagemaker-0.0.4.tar.xz"
  sha256 "66adacd705a7d19895e08eac46d1e851332adf2e736c566bef1164e7a442519d"

  bottle do
    cellar :any
    sha256 "9759e3d26a09e7b99bbf3c49f05bfa7724334b639245f5791d9bada9df977d68" => :catalina
    sha256 "05fafc8fea710cc53cd310192364d72b9458114b5404fdff8f6adbff2f9175bf" => :mojave
    sha256 "db0f93e5cf4cb6dfe4810b7cb8240db5c2c439a717d09def2f6163e3db6984c6" => :high_sierra
    sha256 "0809994f61c8cd34e4edca3496273f293d314e89da5e8ec2a3df280cf436ba37" => :sierra
    sha256 "10c23ab2759830f22ff8080cd4da18252fb719445bd651ab4664e785682c100a" => :el_capitan
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
