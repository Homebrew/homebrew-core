class Help2man < Formula
  desc "Automatically generate simple man pages"
  homepage "https://www.gnu.org/software/help2man/"
  url "https://ftp.gnu.org/gnu/help2man/help2man-1.48.2.tar.xz"
  mirror "https://ftpmirror.gnu.org/help2man/help2man-1.48.2.tar.xz"
  sha256 "20cb36111df91d61741a20680912ab0e4c59da479c3fb05837c6f0a8cb7cb467"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "198f94b5456874c9bdbb114c0a3bfb437bfee75350889607422cf0edd33ee072"
    sha256 cellar: :any,                 big_sur:       "b63cad958b04a3734227f0411ea207aede52af2ea15ecb3ae1b593d0f2b750ab"
    sha256 cellar: :any,                 catalina:      "784418f2d28cf1e2c9a5ae96b1769377ce18bee20ced9ea8fdbd574a941858ee"
    sha256 cellar: :any,                 mojave:        "4343e8f70478cc579f72f0382ad7680a7f5ab4f6b2122d4f4804ad0a633f12eb"
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
