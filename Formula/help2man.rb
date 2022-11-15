class Help2man < Formula
  desc "Automatically generate simple man pages"
  homepage "https://www.gnu.org/software/help2man/"
  url "https://ftp.gnu.org/gnu/help2man/help2man-1.49.2.tar.xz"
  mirror "https://ftpmirror.gnu.org/help2man/help2man-1.49.2.tar.xz"
  sha256 "9e2e0e213a7e0a36244eed6204d902b6504602a578b6ecd15268b1454deadd36"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f5b0bf73ebf258cb4870683c6baf8a4a029d3c46c2996413a6602ef049baf6cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5b0bf73ebf258cb4870683c6baf8a4a029d3c46c2996413a6602ef049baf6cd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f5b0bf73ebf258cb4870683c6baf8a4a029d3c46c2996413a6602ef049baf6cd"
    sha256 cellar: :any,                 ventura:        "364fc43f7b2281c96d22494ed9f2eccec465a00cceb8e7e3169213aab6b51232"
    sha256 cellar: :any,                 monterey:       "0481c92c77f5a3fd47271eb8a4ce4e69ac65cdd9725648fa395a2e0c5a72a30c"
    sha256 cellar: :any,                 big_sur:        "9ad7fec41ef9f551d6fa6b0f15cc0bce69253daf0e2d1e2c0f25b14d5ca2c045"
    sha256 cellar: :any,                 catalina:       "758ca628b5bd9e705848c5ec78b2c00d61cd1a5b4363751ccc06bf146b019c72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e934fa20f035226d407cb5c429ee6ae91b95710a4fd2c4445b26438d56c3450"
  end

  uses_from_macos "perl", since: :mojave

  on_intel do
    depends_on "gettext"
  end

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
