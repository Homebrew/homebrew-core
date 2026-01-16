class Libusb < Formula
  desc "Library for USB device access"
  homepage "https://libusb.info/"
  url "https://github.com/libusb/libusb/releases/download/v1.0.29/libusb-1.0.29.tar.bz2"
  sha256 "5977fc950f8d1395ccea9bd48c06b3f808fd3c2c961b44b0c2e6e29fc3a70a85"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b7e94047913739bcf330be575aa4a6f09f4008ffc7c6289fd7f52a0af8ca55f2"
    sha256 cellar: :any,                 arm64_sequoia: "197c6a9c929f846cacdb7e79376a706ba295bf7f9a5aa49ac9712b9d6a571962"
    sha256 cellar: :any,                 arm64_sonoma:  "63ea19dcae1a6e9b82b9d2d8497367f29b2baf337aa30bf69abc1a37252078b3"
    sha256 cellar: :any,                 arm64_ventura: "c5c93e938ae936589f352d213e24cff2a02990e08efb8e7620c45075b1301f50"
    sha256 cellar: :any,                 sonoma:        "ace918b6a959314990d4653e81496f99594e2999f5a36fd61f538fa3b469db3f"
    sha256 cellar: :any,                 ventura:       "ecf25be7aa95c979306f6054a6de8aa4dadd380f17341ffdda2259e48a01a213"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc6fdd8e4ea046dbe90ba929765570c3066d4463d37da4e055b69297c954994c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70face621f55df85bc16900355953c3ea8f522d7e9f030df490c3494e8898b2c"
  end

  head do
    url "https://github.com/libusb/libusb.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  on_linux do
    depends_on "systemd"
  end

  def install
    args = %W[--disable-dependency-tracking --prefix=#{prefix}]

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"
    (pkgshare/"examples").install Dir["examples/*"] - Dir["examples/Makefile*"]
  end

  test do
    cp_r (pkgshare/"examples"), testpath
    cd "examples" do
      system ENV.cc, "listdevs.c", "-L#{lib}", "-I#{include}/libusb-1.0",
             "-lusb-1.0", "-o", "test"
      system "./test"
    end
  end
end
