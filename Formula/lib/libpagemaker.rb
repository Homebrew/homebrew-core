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

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "d9e3c687bbf276008a19981600851d145d6bf8f6ce17a689bb3aea7c3c3722ed"
    sha256 cellar: :any,                 arm64_sequoia:  "8b12308a14b296bf195cae2a64b4242efb1dfa589903d3312d1543a4e3891bfb"
    sha256 cellar: :any,                 arm64_sonoma:   "405ba95d6cd51308c1cd722631bb34f78702b5c40e8a70aac0422d551c6e1bcc"
    sha256 cellar: :any,                 arm64_ventura:  "e35968d7b7068c1ebcd5a7243ff34d6a54b2c5f1e11e223f43146e9d77686cda"
    sha256 cellar: :any,                 arm64_monterey: "a092569342b5f5d3495f4a66247a2e30c419a3dd242dd74467e4de99c237b290"
    sha256 cellar: :any,                 arm64_big_sur:  "e95a8d6dca9411adefbeb5bebd6e34112f0deec1ec9fe0d8f9bea5502f2a7a37"
    sha256 cellar: :any,                 sonoma:         "8d79e822a3f2a831e7aecd377a81259a9091f7f1e5aec0c4c61a769618cad2c5"
    sha256 cellar: :any,                 ventura:        "6d72068712d51e67e5cbefdc4a3b7fa69477792bd8978555b0d0aeebd193803f"
    sha256 cellar: :any,                 monterey:       "ab84fad8e27045fcff614f404a2768caa62c4cdaff8cd4eebde7a295b49115fc"
    sha256 cellar: :any,                 big_sur:        "ccdd8cd950304039a111f5ee80658b809c040d83f6321701384bc96dc596b569"
    sha256 cellar: :any,                 catalina:       "9759e3d26a09e7b99bbf3c49f05bfa7724334b639245f5791d9bada9df977d68"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "bb6dd8ea44bbb80e0aab25f34c43061d030241747985963d7e60787a1d087c98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9fc80c8b825f43efef4c8dd33e069eda4b3180ed908b74185286099829c625f9"
  end

  depends_on "boost" => :build
  depends_on "pkgconf" => :build
  depends_on "librevenge"

  def install
    system "./configure", "--without-docs",
                          "--enable-static=no",
                          *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <libpagemaker/libpagemaker.h>
      int main() {
        libpagemaker::PMDocument::isSupported(0);
      }
    CPP
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
