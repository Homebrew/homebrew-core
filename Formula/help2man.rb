class Help2man < Formula
  desc "Automatically generate simple man pages"
  homepage "https://www.gnu.org/software/help2man/"
  url "https://ftp.gnu.org/gnu/help2man/help2man-1.48.3.tar.xz"
  mirror "https://ftpmirror.gnu.org/help2man/help2man-1.48.3.tar.xz"
  sha256 "8361ff3c643fbd391064e97e5f54592ca28b880eaffbf566a68e0ad800d1a8ac"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "245bca74657364e44328ea73adba991dc474575fb06e2d7a6265ebefebfc3d4f"
    sha256 cellar: :any,                 big_sur:       "3427e6a3047c47d3fa9d82e84484c37670a6c4f535e9e5d43a722ca0099854a5"
    sha256 cellar: :any,                 catalina:      "86c79d4bdae5e7ed98a3c7f12e03e8ae30441671f265039302d8e3bf99b9efa6"
    sha256 cellar: :any,                 mojave:        "17a7fb449651786f446b6b4baa6a53a0b58ded567c83730b3e6fc2a86a4ff7ed"
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
