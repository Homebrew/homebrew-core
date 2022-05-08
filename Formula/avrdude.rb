class Avrdude < Formula
  desc "Atmel AVR MCU programmer"
  homepage "https://savannah.nongnu.org/projects/avrdude/"
  license "GPL-2.0-or-later"

  stable do
    url "https://download.savannah.gnu.org/releases/avrdude/avrdude-7.0.tar.gz"
    mirror "https://download-mirror.savannah.gnu.org/releases/avrdude/avrdude-7.0.tar.gz"
    sha256 "c0ef65d98d6040ca0b4f2b700d51463c2a1f94665441f39d15d97442dbb79b54"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  livecheck do
    url "https://download.savannah.gnu.org/releases/avrdude/"
    regex(/href=.*?avrdude[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256                               arm64_monterey: "88e4777272b8683adae663acb706cf43beb2028c710d1992427c5f707f4f8b29"
    sha256                               arm64_big_sur:  "5bc7fc2c1788569a0cc0bb6ec92e4d0b3524ff79f811fbeac7a67fca7c5d71bc"
    sha256                               monterey:       "46ddac33efce94c5b7d02e2110050473ea98a0ad63a4162689d758e4c699103c"
    sha256                               big_sur:        "bf71cc8ec0970e78c6a2a081f6b99946ffa7405714708841e5b65c993af27da6"
    sha256                               catalina:       "f7c8d3e57f8ac80d916e4974009c8032e4e981f91d56aa016c3fd8cfe13e8723"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c0284a107537fce66117114410df6989a15acf66e03e6016be19986041877bf"
  end

  head do
    url "https://svn.savannah.nongnu.org/svn/avrdude/trunk/avrdude"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "automake" => :build
  depends_on "hidapi"
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
    assert_match "avrdude done.  Thank you.",
      shell_output("#{bin}/avrdude -c jtag2 -p x16a4 2>&1", 1).strip
  end
end
