class Help2man < Formula
  desc "Automatically generate simple man pages"
  homepage "https://www.gnu.org/software/help2man/"
  url "https://ftp.gnu.org/gnu/help2man/help2man-1.48.5.tar.xz"
  mirror "https://ftpmirror.gnu.org/help2man/help2man-1.48.5.tar.xz"
  sha256 "6739e4caa42e6aed3399be4387ca79399640967334e91728863b8eaa922582be"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f0773ffb77e0e13dce87ce7726fe3f29184f431c345840c7dc869a3b6cf276d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5f0773ffb77e0e13dce87ce7726fe3f29184f431c345840c7dc869a3b6cf276d"
    sha256 cellar: :any,                 monterey:       "49e2e969ec8ed1c4f7954d0236fd64719e102a128c42af685767bfc5f213ac07"
    sha256 cellar: :any,                 big_sur:        "49eb6e847eeb7e51779289d351a337ef0c6cba97ac079806066747456036d8e6"
    sha256 cellar: :any,                 catalina:       "4abfd6faab1e8286a08da1874e46ebf8a32812f84953740b08ddf2b17be6eb3c"
    sha256 cellar: :any,                 mojave:         "8586eeac3d452b94b08a519bc01a4887e534832e7be01aa1c0c5bfefeda5b6a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1316c8afe193ef525f86ba791f23557ac403d68b14677e6e29ba536df59a0be"
  end

  depends_on "gettext" if Hardware::CPU.intel?

  uses_from_macos "perl"

  resource "Locale::gettext" do
    url "https://cpan.metacpan.org/authors/id/P/PV/PVANDRY/gettext-1.07.tar.gz"
    sha256 "909d47954697e7c04218f972915b787bd1244d75e3bd01620bc167d5bbc49c15"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    if Hardware::CPU.intel?
      resource("Locale::gettext").stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make", "install"
      end
    end

    # install is not parallel safe
    # see https://github.com/Homebrew/homebrew/issues/12609
    ENV.deparallelize

    args = []
    args << "--enable-nls" if Hardware::CPU.intel?

    system "./configure", "--prefix=#{prefix}", *args
    system "make", "install"
    (libexec/"bin").install "#{bin}/help2man"
    (bin/"help2man").write_env_script("#{libexec}/bin/help2man", PERL5LIB: ENV["PERL5LIB"])
  end

  test do
    out = if Hardware::CPU.intel?
      shell_output("#{bin}/help2man --locale=en_US.UTF-8 #{bin}/help2man")
    else
      shell_output("#{bin}/help2man #{bin}/help2man")
    end

    assert_match "help2man #{version}", out
  end
end
