class Libwandevent < Formula
  desc "API for developing event-driven programs"
  homepage "https://research.wand.net.nz/software/libwandevent.php"
  url "https://research.wand.net.nz/software/libwandevent/libwandevent-3.0.2.tar.gz"
  sha256 "48fa09918ff94f6249519118af735352e2119dc4f9b736c861ef35d59466644a"

  bottle do
    cellar :any
    sha256 "1e1db4ade4de58ab9ca1f0545d91537b935b65e062d99737c288dd059a17da8e" => :mojave
    sha256 "7593e96a9e76e4b67fa3851a3491c8d7cbd458ad53ff65b3a34b64e2f697e75b" => :high_sierra
    sha256 "e4b00ade9387b8fdccf72bbe9edd0e334c69f23597f85dd1e6da02088703c286" => :sierra
    sha256 "f1459d39284b520c17443c6bef5ccb641dfe1e20266a4f34071f6a87cd9669e4" => :el_capitan
    sha256 "b8c90b8dca1d0ded39036d7f23b4e33857c7914e178ba8ac8870ab702f96fa04" => :yosemite
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <sys/time.h>
      #include <libwandevent.h>

      int main() {
        wand_event_init();
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-L#{lib}", "-lwandevent", "-o", "test"
    system "./test"
  end
end
