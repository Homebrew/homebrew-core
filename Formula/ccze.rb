class Ccze < Formula
  desc "Robust and modular log colorizer"
  homepage "https://packages.debian.org/wheezy/ccze"
  url "https://deb.debian.org/debian/pool/main/c/ccze/ccze_0.2.1.orig.tar.gz"
  sha256 "8263a11183fd356a033b6572958d5a6bb56bfd2dba801ed0bff276cfae528aa3"
  license "GPL-2.0"
  revision 1

  bottle do
    cellar :any
    rebuild 2
    sha256 "1d7fe7ec73840e77d3f76f6f9d38757e4ab62d9d6a951e6d9ccf83782f73a29a" => :catalina
    sha256 "f748556612ca69454aec71083d8cedbb3def5091c9663c7df046c597fe26048f" => :mojave
    sha256 "fdc8abe565f7cec57dd3461d6840e2676c556fa54eaccada60df4958310ff8a7" => :high_sierra
  end

  # query via the last repo status change `https://api.github.com/repos/madhouse/ccze`
  deprecate! date: "2020-05-24", because: :repo_archived

  depends_on "pcre"

  uses_from_macos "ncurses"

  def install
    # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=823334
    inreplace "src/ccze-compat.c", "#if HAVE_SUBOPTARg", "#if HAVE_SUBOPTARG"
    # Allegedly from Debian & fixes compiler errors on old OS X releases.
    # https://github.com/Homebrew/legacy-homebrew/pull/20636
    inreplace "src/Makefile.in", "-Wreturn-type -Wswitch -Wmulticharacter",
                                 "-Wreturn-type -Wswitch"

    system "./configure", "--prefix=#{prefix}",
                          "--with-builtins=all"
    system "make", "install"
    # Strange but true: using --mandir above causes the build to fail!
    share.install prefix/"man"
  end

  test do
    system "#{bin}/ccze", "--help"
  end
end
