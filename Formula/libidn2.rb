class Libidn2 < Formula
  desc "International domain name library (IDNA2008, Punycode and TR46)"
  homepage "https://www.gnu.org/software/libidn/#libidn2"
  url "https://ftp.gnu.org/gnu/libidn/libidn2-2.1.0.tar.gz"
  mirror "https://ftpmirror.gnu.org/libidn/libidn2-2.1.0.tar.gz"
  sha256 "032398dbaa9537af43f51a8d94e967e3718848547b1b2a4eb3138b20cad11d32"

  bottle do
    sha256 "bed41502a268a78e11ee1ae8fd055703445970304dc918c0ef91acdf88128fc2" => :mojave
    sha256 "5a772d41138cf7d83e338011ae9e6c943206a6feef0f7ce6f4eb31527c96e991" => :high_sierra
    sha256 "ac2891ed72664c65c95398d51b8350e76f41236899e3d6d346ffa0fad4ff00c1" => :sierra
    sha256 "3a5558ab5f48f68b8d3f855343146a879b1b1a02811e6a6d5792e7da96bcd56b" => :el_capitan
  end

  head do
    url "https://gitlab.com/libidn/libidn2.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gengetopt" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "libunistring"

  def install
    if build.head?
      ENV["GEM_HOME"] = buildpath/"gem_home"
      system "gem", "install", "ronn"
      ENV.prepend_path "PATH", buildpath/"gem_home/bin"
      system "./bootstrap"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-libintl-prefix=#{Formula["gettext"].opt_prefix}",
                          "--with-packager=Homebrew"
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
