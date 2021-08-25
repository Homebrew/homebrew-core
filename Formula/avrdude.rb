class Avrdude < Formula
  desc "Atmel AVR MCU programmer"
  homepage "https://savannah.nongnu.org/projects/avrdude/"
  url "https://download.savannah.gnu.org/releases/avrdude/avrdude-6.3.tar.gz"
  mirror "https://download-mirror.savannah.gnu.org/releases/avrdude/avrdude-6.3.tar.gz"
  sha256 "0f9f731b6394ca7795b88359689a7fa1fba818c6e1d962513eb28da670e0a196"
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url "https://download.savannah.gnu.org/releases/avrdude/"
    regex(/href=.*?avrdude[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256                               arm64_big_sur: "5f2a5f228b32d34036bc9d2909212523fe6f0be30812e61c20d867e236181bfc"
    sha256                               big_sur:       "08ea02dd2d51688a0f0b590c16f98e055909f7177536d74bafec8a9db6b5787e"
    sha256                               catalina:      "3c30bd1e1bd1419b23b04aa6103600d0691ea6c88967fa721f482c5194105f11"
    sha256                               mojave:        "0def40dd2ad77f5baf9b31b95678994a795c5691fec160ed3e2e5bbd96c36f74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d251e554f650596a0f491f5b71e5f2af54da8226fdbd61cdbfe87f25776297a6"
  end

  head do
    url "https://svn.savannah.nongnu.org/svn/avrdude/trunk/avrdude"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "automake" => :build
  depends_on "libftdi0"
  depends_on "libhid"
  depends_on "libusb-compat"

  uses_from_macos "bison"
  uses_from_macos "flex"

  on_macos do
    depends_on "libelf"
  end

  on_linux do
    depends_on "elfutils"
  end

  def install
    # Workaround for ancient config files not recognizing aarch64 macos.
    am = Formula["automake"]
    am_share = am.opt_share/"automake-#{am.version.major_minor}"
    %w[config.guess config.sub].each do |fn|
      chmod "u+w", fn
      cp am_share/fn, fn
    end

    if build.head?
      inreplace "bootstrap", /libtoolize/, "glibtoolize"
      system "./bootstrap"
    end
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "avrdude done.  Thank you.",
      shell_output("#{bin}/avrdude -c jtag2 -p x16a4 2>&1", 1).strip
  end
end
