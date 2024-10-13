class Help2man < Formula
  desc "Automatically generate simple man pages"
  homepage "https://www.gnu.org/software/help2man/"
  url "https://ftp.gnu.org/gnu/help2man/help2man-1.49.3.tar.xz"
  mirror "https://ftpmirror.gnu.org/help2man/help2man-1.49.3.tar.xz"
  sha256 "4d7e4fdef2eca6afe07a2682151cea78781e0a4e8f9622142d9f70c083a2fd4f"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "302508e981921582b36f4846678b1ea739815f9bcc7b9cf96b0b40b3197ba9e3"
    sha256 cellar: :any,                 arm64_sonoma:   "cbbe4be42473a8911941a77ab20a064a3e5429c943d8fd55b187008e1687009e"
    sha256 cellar: :any,                 arm64_ventura:  "c875f5b7412c9b503a3a6c855530d01d014217eba3589e6618b1a0678e0790ee"
    sha256 cellar: :any,                 arm64_monterey: "e2bc370f6b6e9bed84fc77b6ca5536c545299b63f4898303dcdbc3af7324a13f"
    sha256 cellar: :any,                 sonoma:         "c7be1329f64b7162d1ae7505f998630f88b58751c84c0240317a77841e250c8a"
    sha256 cellar: :any,                 ventura:        "d70c0e7c8cd5293d48c2c93071c8262ba9116b257fe85622623c7ab3e61b3a7a"
    sha256 cellar: :any,                 monterey:       "9e5ca214c3b4bcdf56e59e3c389dc86678dc33c1d9961a5764a8dba8f63cd1ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49b4060b6a6027b81ea7a68db3b32d91d704a55d01bcb1c73e750963259e64f2"
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

    args = []
    args << "--enable-nls" if Hardware::CPU.intel?

    system "./configure", "--prefix=#{prefix}", *args
    system "make", "install"
    (libexec/"bin").install bin/"help2man"
    (bin/"help2man").write_env_script("#{libexec}/bin/help2man", PERL5LIB: ENV["PERL5LIB"])
  end

  test do
    out = shell_output("#{bin}/help2man --locale=en_US.UTF-8 #{bin}/help2man")

    assert_match "help2man #{version}", out
  end
end
