class Ccze < Formula
  desc "Robust and modular log colorizer"
  homepage "https://packages.debian.org/wheezy/ccze"
  url "https://deb.debian.org/debian/pool/main/c/ccze/ccze_0.2.1.orig.tar.gz"
  sha256 "8263a11183fd356a033b6572958d5a6bb56bfd2dba801ed0bff276cfae528aa3"
  license "GPL-2.0"
  revision 1

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_monterey: "3f243fe0619da9ccf67d6b9546c93167e0993315fd9f280657b252be707b8fbc"
    sha256 cellar: :any, arm64_big_sur:  "b518785dfd98c9b08ae78f31fb72047d2fd26a8c3e96ceccdceaf6ba27dab97c"
    sha256 cellar: :any, monterey:       "4b65eb547ec1ad843ffddebbb23769f80f43258522e145b99803309871c568ae"
    sha256 cellar: :any, big_sur:        "c371f991787765a9ac035987d594b478a4a4bfcd1a1581990c3a86edfcdb5067"
    sha256 cellar: :any, catalina:       "1d7fe7ec73840e77d3f76f6f9d38757e4ab62d9d6a951e6d9ccf83782f73a29a"
    sha256 cellar: :any, mojave:         "f748556612ca69454aec71083d8cedbb3def5091c9663c7df046c597fe26048f"
    sha256 cellar: :any, high_sierra:    "fdc8abe565f7cec57dd3461d6840e2676c556fa54eaccada60df4958310ff8a7"
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
