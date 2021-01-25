class Help2man < Formula
  desc "Automatically generate simple man pages"
  homepage "https://www.gnu.org/software/help2man/"
  url "https://ftp.gnu.org/gnu/help2man/help2man-1.47.17.tar.xz"
  mirror "https://ftpmirror.gnu.org/help2man/help2man-1.47.17.tar.xz"
  sha256 "da3a35c50b1e1f8c8fa322d69fa47c9011ce443a8fb8d1d671b1f01b8b0008eb"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "ee60622e70903c293171ea78097544d796a5454b29e8c1494529aa537901e460" => :big_sur
    sha256 "7bc46236d8916519b432020f2d51df5c6006c7000b67835ff7e1276c58ec208c" => :arm64_big_sur
    sha256 "603b604aaf17770dd4f4a0f9b45c266848d8c005228c64773fdec2d94e3d45dd" => :catalina
    sha256 "f57b3269934c79434b70ac7807ea364af47ae8a3b6096364c0615b2789d4a0a9" => :mojave
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
