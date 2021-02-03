class Avrdude < Formula
  desc "Atmel AVR MCU programmer"
  homepage "https://savannah.nongnu.org/projects/avrdude/"
  url "https://download.savannah.gnu.org/releases/avrdude/avrdude-6.3.tar.gz"
  mirror "https://download-mirror.savannah.gnu.org/releases/avrdude/avrdude-6.3.tar.gz"
  sha256 "0f9f731b6394ca7795b88359689a7fa1fba818c6e1d962513eb28da670e0a196"
  revision 1

  livecheck do
    url "https://download.savannah.gnu.org/releases/avrdude/"
    regex(/href=.*?avrdude[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 big_sur:     "80bd53f8b78f172aaea62b9a58f6febfc4ac4b510969511ab0f3e06da9adb1bb"
    sha256 catalina:    "d3f4c82170fa37bacd6e1bc3276ba27e7a8ed2ea781b101b7899e7602393a15b"
    sha256 mojave:      "65fe6de6f540eb1c6ad94d35c847f8a5921cc9059ff044d1bc78f68cc8b8334b"
    sha256 high_sierra: "b0cb94b5c4f01fcc870f286bca293218c98fda23d76397db8a831272f7087038"
    sha256 sierra:      "e8e26af5565cd897867d4e6e71e66e6e946e1e21eb4e27d3cd49f199f088fc5d"
    sha256 el_capitan:  "c953526dc893a9b162a109d074edf8bb71d7049c63990282edc994c63de90c44"
  end

  head do
    url "https://svn.savannah.nongnu.org/svn/avrdude/trunk/avrdude"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "libelf"
  depends_on "libftdi0"
  depends_on "libhid"
  depends_on "libusb-compat"

  def install
    if build.head?
      inreplace "bootstrap", /libtoolize/, "glibtoolize"
      system "./bootstrap"
    end
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "avrdude done.  Thank you.",
      shell_output("#{bin}/avrdude -c jtag2 -p x16a4 2>&1", 1).strip
  end
end
