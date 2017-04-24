class LibidnAT2 < Formula
  desc "International domain name library"
  homepage "https://www.gnu.org/software/libidn/#libidn2"
  url "https://ftp.gnu.org/gnu/libidn/libidn2-2.0.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/libidn/libidn2-2.0.1.tar.xz"
  sha256 "85bc255b936068d0cab3ea6c1a07e7c23b84a4cff4d1c345ee97d2f629173f47"

  head do
    url "https://gitlab.com/libidn/libidn2.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
    depends_on "gettext" => :build
    depends_on "gengetopt" => :build
  end

  keg_only :versioned_formula

  depends_on "pkg-config" => :build
  depends_on "libunistring"

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-packager=Homebrew"

    # This is fixed already upstream by:
    # https://gitlab.com/libidn/libidn2/commit/4caef557
    # but by using inreplace we can avoid treating this like HEAD.
    if build.stable?
      inreplace "Makefile" do |s|
        s.gsub! "TMPDIR", "ABI_TMPDIR"
        s.gsub! "TMPFILE", "ABI_TMPFILE"
      end
    end
    system "make", "install"
  end

  test do
    ENV["CHARSET"] = "UTF-8"
    system bin/"idn2", "räksmörgås.se", "blåbærgrød.no"
  end
end
