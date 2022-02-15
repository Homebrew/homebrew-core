class Help2man < Formula
  desc "Automatically generate simple man pages"
  homepage "https://www.gnu.org/software/help2man/"
  url "https://ftp.gnu.org/gnu/help2man/help2man-1.49.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/help2man/help2man-1.49.1.tar.xz"
  sha256 "fd99a664ec4be9a86a0dd89719989f14f367a9c079d75d0e1d71e18a7bb51b03"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a5d861e17cce90ad93cd77ac048a8fb4710cb7690bae264653fda06780282aa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2a5d861e17cce90ad93cd77ac048a8fb4710cb7690bae264653fda06780282aa"
    sha256 cellar: :any,                 monterey:       "d8865b2976749558b98909feeb26b63435a430dbbe5ccd190d490f0ccad0ff3d"
    sha256 cellar: :any,                 big_sur:        "005f3e09437c5372a0b7e4e094618d1056998fde46320d676e14d3ef8187b155"
    sha256 cellar: :any,                 catalina:       "55b35783121c456e3681fa9eab2f2129c40cfffb3e354ee36f2d0e6a120182f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "524924459d3f94ea7d9feb39972df90c53988362b5982bf2cd855caa68057469"
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
