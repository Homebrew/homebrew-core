class Libidn2 < Formula
  desc "International domain name library (IDNA2008, Punycode and TR46)"
  homepage "https://www.gnu.org/software/libidn/#libidn2"
  url "https://ftpmirror.gnu.org/gnu/libidn/libidn2-2.3.8.tar.gz"
  mirror "https://ftp.gnu.org/gnu/libidn/libidn2-2.3.8.tar.gz"
  mirror "http://ftp.gnu.org/gnu/libidn/libidn2-2.3.8.tar.gz"
  sha256 "f557911bf6171621e1f72ff35f5b1825bb35b52ed45325dcdee931e5d3c0787a"
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
    sha256 arm64_tahoe:   "f8f1b459f15a4ac11d2dce786a9140509782227b7d499cbdf3a1279dd325d90b"
    sha256 arm64_sequoia: "1eb02bfa40ec00b7ea64d8608fcf2115069d99de5a35eb3e2b3ac444a695ea46"
    sha256 arm64_sonoma:  "6c578e128c82759e211298ae9b004c83844c2626c074f5cf4950402399bdb8f1"
    sha256 arm64_ventura: "d0d933dad3ab921d09acd3fe3efa952ee8859f3d9d03aa0210490aca25e0c544"
    sha256 sonoma:        "ef2c85790a55f54f58fceb849e1ee46f2b06ebe516c83043e68c979e47934e6f"
    sha256 ventura:       "96fdb47b24345178dae4b88855adafb51efbca9797d6de046f117b26e7674d74"
    sha256 arm64_linux:   "25d5d1e8d6893f66f15c0f94f88be9618d47e5cd65d6391d938478d3cf75c7b0"
    sha256 x86_64_linux:  "9e8c065bb543ee967667db82c00185419a108555ecbd965b2e6cebe202472e7f"
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

  depends_on "pkgconf" => :build
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
