class Cpansearch < Formula
  desc "CPAN module search written in C"
  homepage "https://github.com/c9s/cpansearch"
  url "https://github.com/c9s/cpansearch/archive/refs/tags/0.2.tar.gz"
  sha256 "09e631f361766fcacd608a0f5b3effe7b66b3a9e0970a458d418d58b8f3f2a74"
  revision 1
  head "https://github.com/c9s/cpansearch.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "6f99905d8bca0790ecf1d11a25cc00e5057f9a552afc1a051530dc9a6271c93c"
    sha256 cellar: :any,                 arm64_ventura:  "559728aeba9f49230296c122a6082e18f188b17b689b015ae87bc3169f07dea3"
    sha256 cellar: :any,                 arm64_monterey: "2a3b8377204fbffa071e4b8493e1c6bd5bf08df9d86d3e447470b55c34304277"
    sha256 cellar: :any,                 arm64_big_sur:  "60c7266ff4239e5a4e1eb31a8831ebe6f3fbaec4d177986dc1e1a8c58f31d335"
    sha256 cellar: :any,                 sonoma:         "1ef7dbcf248244b629d880236d70c50aa950baa10aeb7e5995ebf41a176dd023"
    sha256 cellar: :any,                 ventura:        "0d363d18d2a5b5a87bac3560266b5af9d3654dd20aedee7fd3b61ab3929beb48"
    sha256 cellar: :any,                 monterey:       "2ef810c08831dc48837d8b3cb0ddcfd13769d8f17397bb62e10f84ce90c2fad1"
    sha256 cellar: :any,                 big_sur:        "facb5cfb7e61d1fecba7f3185230c405abcdcf213dc779749fef25c47e72be63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f88cd961acac2cdd3fd6711aea3c5e7fde3a23356c0a299f08cf440bed88d7d"
  end

  # upstream missing license report, https://github.com/c9s/cpansearch/issues/5
  disable! date: "2024-08-10", because: :no_license

  depends_on "pkg-config" => :build

  depends_on "glib"
  depends_on "ncurses"

  uses_from_macos "curl"

  on_macos do
    depends_on "gettext"
    depends_on "pcre2"
  end

  def install
    unless OS.mac?
      # Help find some ncursesw headers
      ENV.append "CPPFLAGS", "-I#{Formula["ncurses"].include}/ncursesw"
      # Temporary Homebrew-specific work around for linker flag ordering problem in Ubuntu 16.04.
      # Remove after migration to 18.04.
      inreplace "Makefile", "$(LDFLAGS) $(OBJS)", "$(OBJS) $(LDFLAGS)"
    end
    system "make"
    bin.install "cpans"
  end

  test do
    output = shell_output("#{bin}/cpans --fetch https://cpan.metacpan.org/")
    assert_match "packages recorded", output
  end
end
