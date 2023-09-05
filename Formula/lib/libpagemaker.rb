class Libpagemaker < Formula
  desc "Imports file format of Aldus/Adobe PageMaker documents"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libpagemaker"
  url "https://dev-www.libreoffice.org/src/libpagemaker/libpagemaker-0.0.4.tar.xz"
  sha256 "66adacd705a7d19895e08eac46d1e851332adf2e736c566bef1164e7a442519d"
  license "MPL-2.0"

  livecheck do
    url "https://dev-www.libreoffice.org/src/"
    regex(/href=["']?libpagemaker[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e35968d7b7068c1ebcd5a7243ff34d6a54b2c5f1e11e223f43146e9d77686cda"
    sha256 cellar: :any,                 arm64_monterey: "a092569342b5f5d3495f4a66247a2e30c419a3dd242dd74467e4de99c237b290"
    sha256 cellar: :any,                 arm64_big_sur:  "e95a8d6dca9411adefbeb5bebd6e34112f0deec1ec9fe0d8f9bea5502f2a7a37"
    sha256 cellar: :any,                 ventura:        "6d72068712d51e67e5cbefdc4a3b7fa69477792bd8978555b0d0aeebd193803f"
    sha256 cellar: :any,                 monterey:       "ab84fad8e27045fcff614f404a2768caa62c4cdaff8cd4eebde7a295b49115fc"
    sha256 cellar: :any,                 big_sur:        "ccdd8cd950304039a111f5ee80658b809c040d83f6321701384bc96dc596b569"
    sha256 cellar: :any,                 catalina:       "9759e3d26a09e7b99bbf3c49f05bfa7724334b639245f5791d9bada9df977d68"
    sha256 cellar: :any,                 mojave:         "05fafc8fea710cc53cd310192364d72b9458114b5404fdff8f6adbff2f9175bf"
    sha256 cellar: :any,                 high_sierra:    "db0f93e5cf4cb6dfe4810b7cb8240db5c2c439a717d09def2f6163e3db6984c6"
    sha256 cellar: :any,                 sierra:         "0809994f61c8cd34e4edca3496273f293d314e89da5e8ec2a3df280cf436ba37"
    sha256 cellar: :any,                 el_capitan:     "10c23ab2759830f22ff8080cd4da18252fb719445bd651ab4664e785682c100a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9fc80c8b825f43efef4c8dd33e069eda4b3180ed908b74185286099829c625f9"
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
