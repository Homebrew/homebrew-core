class Help2man < Formula
  desc "Automatically generate simple man pages"
  homepage "https://www.gnu.org/software/help2man/"
  url "https://ftp.gnu.org/gnu/help2man/help2man-1.47.16.tar.xz"
  mirror "https://ftpmirror.gnu.org/help2man/help2man-1.47.16.tar.xz"
  sha256 "3ef8580c5b86e32ca092ce8de43df204f5e6f714b0cd32bc6237e6cd0f34a8f4"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "0df51bfb13aae7a1cc8fefd2d5853d5659ef29bd676ae1b84de1c5775fd46475" => :catalina
    sha256 "0c6508b21593f464813e5d0f813801fb26af4792bb8cc4aaee0a4ad9b44350f9" => :mojave
    sha256 "46f3e7058af47162c5649eed42b2e573b27ac2187f0c397e83357e0ba0724e93" => :high_sierra
  end

  depends_on "gettext"

  uses_from_macos "perl"

  resource "Locale::gettext" do
    url "https://cpan.metacpan.org/authors/id/P/PV/PVANDRY/gettext-1.07.tar.gz"
    sha256 "909d47954697e7c04218f972915b787bd1244d75e3bd01620bc167d5bbc49c15"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    resources.each do |r|
      r.stage do
        args = ["INSTALL_BASE=#{libexec}"]
        args.unshift "--defaultdeps" if r.name == "MIME::Charset"
        system "perl", "Makefile.PL", *args
        system "make", "install"
      end
    end

    # install is not parallel safe
    # see https://github.com/Homebrew/homebrew/issues/12609
    ENV.deparallelize

    system "./configure", "--prefix=#{prefix}", "--enable-nls"
    system "make", "install"
    (libexec/"bin").install "#{bin}/help2man"
    (bin/"help2man").write_env_script("#{libexec}/bin/help2man", PERL5LIB: ENV["PERL5LIB"])
  end

  test do
    assert_match "help2man #{version}", shell_output("#{bin}/help2man --locale=en_US.UTF-8 #{bin}/help2man")
  end
end
