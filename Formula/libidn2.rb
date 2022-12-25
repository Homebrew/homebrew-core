class Libidn2 < Formula
  desc "International domain name library (IDNA2008, Punycode and TR46)"
  homepage "https://www.gnu.org/software/libidn/#libidn2"
  url "https://ftp.gnu.org/gnu/libidn/libidn2-2.3.4.tar.gz"
  mirror "https://ftpmirror.gnu.org/libidn/libidn2-2.3.4.tar.gz"
  mirror "http://ftp.gnu.org/gnu/libidn/libidn2-2.3.4.tar.gz"
  sha256 "93caba72b4e051d1f8d4f5a076ab63c99b77faee019b72b9783b267986dbb45f"
  license any_of: ["GPL-2.0-or-later", "LGPL-3.0-or-later"]
  revision 1

  livecheck do
    url :stable
    regex(/href=.*?libidn2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "5550bc39dcb606b7a89893d18e665603f40b741a6c2d9b0c06fc4be30ae568d7"
    sha256 arm64_monterey: "baf8ea36355b9ebdefea47a68899a5774b0cdd4310fdf9381548ff1cd92ed917"
    sha256 arm64_big_sur:  "670adac962dad9344631839771a3b2db4206f1b4ea1ff03313c7af953c48d90b"
    sha256 ventura:        "d6aad8bc36d9c4e3b60e8eceb8efff287bc70be8a41d625ce823a84b666997ac"
    sha256 monterey:       "b3f82e7085f5b3275ce37c010ae972c810d01857fe18256dd7e1fcbfa357ac32"
    sha256 big_sur:        "542dd4872c2c94152f7b253f923fd2187d8e87e65eff9f3437739ce9426edff0"
    sha256 x86_64_linux:   "eddbc802ee4f200770aff95da72c0c0f052a75970a3f17103d3fb42b36615819"
  end

  head do
    url "https://gitlab.com/libidn/libidn2.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gengetopt" => :build
    depends_on "gettext" => :build
    depends_on "help2man" => :build
    depends_on "libtool" => :build
    depends_on "ronn" => :build

    uses_from_macos "gperf" => :build

    on_system :linux, macos: :ventura_or_newer do
      depends_on "texinfo" => :build
    end
  end

  depends_on "pkg-config" => :build
  depends_on "libunistring"

  on_macos do
    depends_on "gettext"
  end

  def install
    args = ["--disable-silent-rules", "--with-packager=Homebrew"]
    args << "--with-libintl-prefix=#{Formula["gettext"].opt_prefix}" if OS.mac?

    system "./bootstrap", "--skip-po" if build.head?
    system "./configure", *std_configure_args, *args
    system "make", "install"
  end

  test do
    ENV.delete("LC_CTYPE")
    ENV["CHARSET"] = "UTF-8"
    output = shell_output("#{bin}/idn2 räksmörgås.se")
    assert_equal "xn--rksmrgs-5wao1o.se", output.chomp
    output = shell_output("#{bin}/idn2 blåbærgrød.no")
    assert_equal "xn--blbrgrd-fxak7p.no", output.chomp
  end
end
