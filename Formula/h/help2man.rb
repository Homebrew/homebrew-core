class Help2man < Formula
  desc "Automatically generate simple man pages"
  homepage "https://www.gnu.org/software/help2man/"
  url "https://ftpmirror.gnu.org/gnu/help2man/help2man-1.49.3.tar.xz"
  mirror "https://ftp.gnu.org/gnu/help2man/help2man-1.49.3.tar.xz"
  sha256 "4d7e4fdef2eca6afe07a2682151cea78781e0a4e8f9622142d9f70c083a2fd4f"
  license "GPL-3.0-or-later"
  revision 4

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d2e8018036792d9b999b50c7230443eececc319f3e51b780f6f10f2228c4641e"
    sha256 cellar: :any,                 arm64_sequoia: "b4559a8766dc2105a09add4cdc05f1c2d80258adca8bdbbacddd48ae53366ffd"
    sha256 cellar: :any,                 arm64_sonoma:  "3e375af068ec798596cd7b215930de6265a6bcc00a233236676ea9717c4a9567"
    sha256 cellar: :any,                 sonoma:        "dd72eaf7288b91985248e14172f3f6e3e466a0f0491e6d5fb9ab16f5d1f0f3f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bcb5c874f13e9a6731574491c5b8dcad637a9117d13272dad0db52164b0c9c0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23f914c836ce3eb3984f9c9688dc48ce7f0024d45454c9114400420b70090091"
  end

  depends_on "gettext"
  depends_on "perl"

  resource "Locale::gettext" do
    url "https://cpan.metacpan.org/authors/id/P/PV/PVANDRY/gettext-1.07.tar.gz"
    sha256 "909d47954697e7c04218f972915b787bd1244d75e3bd01620bc167d5bbc49c15"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    resource("Locale::gettext").stage do
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
