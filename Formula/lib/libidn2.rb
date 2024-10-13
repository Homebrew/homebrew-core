class Libidn2 < Formula
  desc "International domain name library (IDNA2008, Punycode and TR46)"
  homepage "https://www.gnu.org/software/libidn/#libidn2"
  url "https://ftp.gnu.org/gnu/libidn/libidn2-2.3.7.tar.gz"
  mirror "https://ftpmirror.gnu.org/libidn/libidn2-2.3.7.tar.gz"
  mirror "http://ftp.gnu.org/gnu/libidn/libidn2-2.3.7.tar.gz"
  sha256 "4c21a791b610b9519b9d0e12b8097bf2f359b12f8dd92647611a929e6bfd7d64"
  license all_of: [
    { any_of: ["GPL-2.0-or-later", "LGPL-3.0-or-later"] }, # lib
    { all_of: ["Unicode-TOU", "Unicode-DFS-2016"] }, # matching COPYING.unicode
    "GPL-3.0-or-later", # bin
    "LGPL-2.1-or-later", # parts of gnulib
    "FSFAP-no-warranty-disclaimer", # man3
  ]

  livecheck do
    url :stable
    regex(/href=.*?libidn2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "1da206a51b4e3550f75e2c980f7f32ad7c75a3824711c534e4b3a9a21fcbaa1a"
    sha256 arm64_sonoma:   "670f6ed3768acde8ce10b5dcfc88fef69cea994ff84491b253a5e818cd4f9a1b"
    sha256 arm64_ventura:  "df4d2b529ac1534d36e44c63aeee6e9be8ee856f3545e75511497de5c60e0e80"
    sha256 arm64_monterey: "621dbb561aeddc8c0d7e856e990414526c43d9da400d3a2a613d2be3c1ebb41f"
    sha256 sonoma:         "32aec190642166c2081088f424cd39cc8b820105ce0b3372d0d8835635424b38"
    sha256 ventura:        "4b4f5eadc82273fb3b0d384466dab53d9fdc7200cbfae1eb5b5bebfe359f4f1e"
    sha256 monterey:       "a1b41989b1decc3a33e8a64a914680c881f9931e2bd2bdac47a9215a4579d686"
    sha256 x86_64_linux:   "2d94c867e00156a44644758c62895dd6d13538aff7f638ea598ff70e0e8f6505"
  end

  head do
    url "https://gitlab.com/libidn/libidn2.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gengetopt" => :build
    depends_on "gettext" => :build
    depends_on "help2man" => :build
    depends_on "libtool" => :build

    uses_from_macos "gperf" => :build

    on_macos do
      depends_on "coreutils" => :build
    end

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

    if build.head?
      ENV.prepend_path "PATH", Formula["coreutils"].libexec/"gnubin" if OS.mac?
      system "./bootstrap", "--skip-po"
    end
    system "./configure", *args, *std_configure_args
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
