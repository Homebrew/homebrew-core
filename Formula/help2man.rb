class Help2man < Formula
  desc "Automatically generate simple man pages"
  homepage "https://www.gnu.org/software/help2man/"
  url "https://ftp.gnu.org/gnu/help2man/help2man-1.49.2.tar.xz"
  mirror "https://ftpmirror.gnu.org/help2man/help2man-1.49.2.tar.xz"
  sha256 "9e2e0e213a7e0a36244eed6204d902b6504602a578b6ecd15268b1454deadd36"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "383b411c2f38bcc248ef62253135047fcdf62d9dc53f8204d8789648705750e2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "383b411c2f38bcc248ef62253135047fcdf62d9dc53f8204d8789648705750e2"
    sha256 cellar: :any,                 monterey:       "2fa2384e5b009445b1c22c3524c290f99097e28f513d05fc72bd34b5a2359c4c"
    sha256 cellar: :any,                 big_sur:        "6d00cbba2327558de78a1e01fc1906ddce81a03067b3d8636f15df835290018a"
    sha256 cellar: :any,                 catalina:       "96ff3329951b52db5e2e70f64e93a5fa291b79d70bc39a4d10d6c2cc3340a1b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "457df4779894e46898cb3ae03f9b7d2650a0bd42e75ab7cdf4aacbe0e6bb90d6"
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
