class Help2man < Formula
  desc "Automatically generate simple man pages"
  homepage "https://www.gnu.org/software/help2man/"
  url "https://ftpmirror.gnu.org/gnu/help2man/help2man-1.49.3.tar.xz"
  mirror "https://ftp.gnu.org/gnu/help2man/help2man-1.49.3.tar.xz"
  sha256 "4d7e4fdef2eca6afe07a2682151cea78781e0a4e8f9622142d9f70c083a2fd4f"
  license "GPL-3.0-or-later"
  revision 4

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "e3d3923d95ff50d31167bb31b79bfb5b5ff04ed958662d6097b87a8e7af80145"
    sha256 cellar: :any,                 arm64_sequoia: "c32c8674bc6c07b61531fcb0e077a4a3566ef57628257bd258992708ec4c0a61"
    sha256 cellar: :any,                 arm64_sonoma:  "1c1953fb1180f4ed0bca07f6befadec13ee94d6a3a7e86607e649457de47dc04"
    sha256 cellar: :any,                 sonoma:        "59d2b48fe6b83c4e94ffda8e2ca12c99825dc11d14042aa4c59033be929f84c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f2a8a07d29e873804a3b89e0f1549813359a0aab0bd5716b66454a1987ded35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9b95c2631c19512416b4e912e95517a81c1d9fddffd53e662e90c76511b6412"
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
      inreplace "Makefile.PL", '$libs = "-lintl"', "$libs = \"-L#{Formula["gettext"].opt_lib} -lintl\"" if OS.mac?

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
