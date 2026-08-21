class Help2man < Formula
  desc "Automatically generate simple man pages"
  homepage "https://www.gnu.org/software/help2man/"
  url "https://ftpmirror.gnu.org/gnu/help2man/help2man-1.49.3.tar.xz"
  mirror "https://ftp.gnu.org/gnu/help2man/help2man-1.49.3.tar.xz"
  sha256 "4d7e4fdef2eca6afe07a2682151cea78781e0a4e8f9622142d9f70c083a2fd4f"
  license "GPL-3.0-or-later"
  revision 5

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e7da765e631d20ed655e5cd3a488288e0922f44b61f2b30d00ba345acfc93999"
    sha256 cellar: :any, arm64_sequoia: "f3ae41d9332c1117fe072a56d5847877eada2b3fc3aa4e6ba872f0aee159f208"
    sha256 cellar: :any, arm64_sonoma:  "261c8dd21fcf7febdcd05f7d6df8ff4159b3da0c4a23f0131090ba87eb381e61"
    sha256 cellar: :any, sonoma:        "2654cbaecdd1429aaa206075492ae392394333143d7b25e4ee1879673dfe5e21"
    sha256 cellar: :any, arm64_linux:   "d847d6874c494a32d659bd7e4a84766a0a6bb4f54f01c66db24c1d2804a38ad1"
    sha256 cellar: :any, x86_64_linux:  "eb20fb548e3eabb081167661c9d3406a3984ace247b5eec71a851e9e4a6de7bc"
  end

  depends_on "gettext"
  uses_from_macos "perl"

  resource "Locale::gettext" do
    url "https://cpan.metacpan.org/authors/id/P/PV/PVANDRY/gettext-1.07.tar.gz"
    sha256 "909d47954697e7c04218f972915b787bd1244d75e3bd01620bc167d5bbc49c15"

    livecheck do
      url :url
    end
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    resource("Locale::gettext").stage do
      # Workaround for macOS perl as MakeMaker can only search libraries in perl compile-time paths
      # Issue ref: https://github.com/Perl-Toolchain-Gang/ExtUtils-MakeMaker/issues/277
      inreplace "Makefile.PL", '$libs = "-lintl"', "$libs = \"-L#{formula_opt_lib("gettext")} -lintl\"" if OS.mac?

      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}", "NO_MYMETA=1"
      system "make", "install"
    end

    # install is not parallel safe
    # see https://github.com/Homebrew/homebrew/issues/12609
    ENV.deparallelize

    system "./configure", "--enable-nls", *std_configure_args
    system "make", "install"
    bin.env_script_all_files(libexec/"bin", PERL5LIB: ENV["PERL5LIB"])
  end

  test do
    out = shell_output("#{bin}/help2man --locale=en_US.UTF-8 #{bin}/help2man")

    assert_match "help2man #{version}", out
  end
end
