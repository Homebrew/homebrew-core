class Libidn2 < Formula
  desc "International domain name library (IDNA2008, Punycode and TR46)"
  homepage "https://www.gnu.org/software/libidn/#libidn2"
  url "https://ftp.gnu.org/gnu/libidn/libidn2-2.1.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/libidn/libidn2-2.1.1.tar.gz"
  sha256 "95416080329298a13269e13175041b530cec3d98b54cafae9424b8dfd22078b1"

  bottle do
    sha256 "55c28ef52807f483fb4907528478c6f9ecb9e9b2fb0da7fcfc41b82e6521a5ac" => :mojave
    sha256 "40e078a0b5164cdddede2de59accd4ab807a118479f9bbe5452a6be61c993be1" => :high_sierra
    sha256 "e64e20552e7ed8d1fb53bd408ba33221e5b5962d738048479de3a9e5bda11024" => :sierra
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
