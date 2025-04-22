class Help2man < Formula
  desc "Automatically generate simple man pages"
  homepage "https://www.gnu.org/software/help2man/"
  url "https://ftp.gnu.org/gnu/help2man/help2man-1.49.3.tar.xz"
  mirror "https://ftpmirror.gnu.org/help2man/help2man-1.49.3.tar.xz"
  sha256 "4d7e4fdef2eca6afe07a2682151cea78781e0a4e8f9622142d9f70c083a2fd4f"
  license "GPL-3.0-or-later"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "253c91cfe267b4e6d99516e9b6243db8de63cd2090feba9a411f0de56ffdc003"
    sha256 cellar: :any,                 arm64_sonoma:  "6fff08f6e2f1e2c1a116771d2cec67f02fd4e5157c5a7468299d625d8708c9c2"
    sha256 cellar: :any,                 arm64_ventura: "ec4c0a8ad5435ebce1cdcc50850121a465da5d591e02cb3264d0b1ddd367dfd5"
    sha256 cellar: :any,                 sonoma:        "e7fee7c80e8f8b0db71ed8f91789676f01f0c25ea7a36dddbe6ac4132a371ffe"
    sha256 cellar: :any,                 ventura:       "f50814222c4bf9afb2f0430b65e058bd893eabd43036e2e8083cb8213b69f10b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2589a1e73bbb7b11ab13b6ba8f60dbd56509377ce07adf66f4f8c4f43e947d54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2fe8b82eddc849ea8cb7b7c2f5a2452bf3bfb5fd8af84e18f5689c1f6966a02"
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
