class Libserialport < Formula
  desc "Cross-platform serial port C library"
  homepage "https://sigrok.org/wiki/Libserialport"
  url "https://sigrok.org/download/source/libserialport/libserialport-0.1.2.tar.gz"
  sha256 "5deb92b5ca72c0347b07b786848350deca2dcfd975ce613b8e0e1d947a4b4ca9"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://sigrok.org/wiki/Downloads"
    regex(/href=.*?libserialport[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "08338366e3223f18ebf2906736598b88648d08835ec45f05fe8f6815b65b7385"
    sha256 cellar: :any,                 arm64_sequoia: "7b4c2b23d05044cd78465a863caab22fd8a1ea1d5938cb4227df56084e69f91a"
    sha256 cellar: :any,                 arm64_sonoma:  "845cc5b5945587d1aa504531d09fea0956c75a6d7ea47dc3a6aa37533e33d74b"
    sha256 cellar: :any,                 arm64_ventura: "d8e517c94d88c00c49c0e7243450f55ca8003cdb3e9b944f972d6673624701de"
    sha256 cellar: :any,                 sonoma:        "e1f99856052b3f5329e02b481347bc28b0a8bdae9de5c99acc6993bcd6d4686d"
    sha256 cellar: :any,                 ventura:       "bd710fe43d3a02c4c7a99663e1c6e5254810cbbdf7f71185d2a49398870503dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9e6ddd7268f8000d0a4fc564fb61025b200ba0a9f66e444c3b06353804ae304"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b61c51d632d2f98386a1eac5eff490bd6cda366f8e5d2edcdde021660ad2006"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libserialport.h>
      int main() {
       struct sp_port *list_ptr = NULL;
       sp_get_port_by_name("some port", &list_ptr);
       return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lserialport",
                   "-o", "test"
    system "./test"
  end
end
