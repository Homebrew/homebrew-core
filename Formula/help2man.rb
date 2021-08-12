class Help2man < Formula
  desc "Automatically generate simple man pages"
  homepage "https://www.gnu.org/software/help2man/"
  url "https://ftp.gnu.org/gnu/help2man/help2man-1.48.4.tar.xz"
  mirror "https://ftpmirror.gnu.org/help2man/help2man-1.48.4.tar.xz"
  sha256 "937194af8e31e97467768ec2e3ce8d396bd1e32e8ea56df23f634485b5f14e09"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "766075b9737decde5d6114154385e55ffdafc9d48b51f220d86768c315c81fc2"
    sha256 cellar: :any,                 big_sur:       "2f29efc97717aaefc4b9717be5e04b98f50c8fff46c9b0abb196963770ce7fe5"
    sha256 cellar: :any,                 catalina:      "5ca4bcc3f5de454d58463e753f3c0ed2eb74882fd2f4846b5dd3b5e64958fc91"
    sha256 cellar: :any,                 mojave:        "e1ede092533cb683d7ed36347ad6969576c0741c6ec4fbcf0ae9879ca934113f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41bc43f6f0c908a43cd0fe9c811017baa1c883ef07573e1b20a632a3a8da9ec2"
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
