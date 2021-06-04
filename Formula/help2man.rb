class Help2man < Formula
  desc "Automatically generate simple man pages"
  homepage "https://www.gnu.org/software/help2man/"
  url "https://ftp.gnu.org/gnu/help2man/help2man-1.48.3.tar.xz"
  mirror "https://ftpmirror.gnu.org/help2man/help2man-1.48.3.tar.xz"
  sha256 "8361ff3c643fbd391064e97e5f54592ca28b880eaffbf566a68e0ad800d1a8ac"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8508861b550d6e89b39702beae40a4c3ff78c9c0d248ea642516edb5f74f0f09"
    sha256 cellar: :any,                 big_sur:       "daa1e20f7225b1b4e64b2b022712a767d238a1dbe07dda53c63dfe1f0f0f8275"
    sha256 cellar: :any,                 catalina:      "337cedb9b9f97c1a1f4e08f3ff79142501d85da4f997c1859cd1dcb05653a836"
    sha256 cellar: :any,                 mojave:        "7d2a720ba3e5020ae28f32cc5705ffd9c8ec7b8b52aed3272d7d43e82eb91c3c"
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
