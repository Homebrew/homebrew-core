class Help2man < Formula
  desc "Automatically generate simple man pages"
  homepage "https://www.gnu.org/software/help2man/"
  url "https://ftp.gnu.org/gnu/help2man/help2man-1.47.16.tar.xz"
  mirror "https://ftpmirror.gnu.org/help2man/help2man-1.47.16.tar.xz"
  sha256 "3ef8580c5b86e32ca092ce8de43df204f5e6f714b0cd32bc6237e6cd0f34a8f4"
  license "GPL-3.0"
  revision 1

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "457a2b1ce094f9997ac5555a843d025eb9bc2267a54be0a1f2292b67a038de72" => :catalina
    sha256 "e06ed538e4c68bec3c3e759ef12961c42288238dd82cdb948e40d6c98733f07d" => :mojave
    sha256 "457a2b1ce094f9997ac5555a843d025eb9bc2267a54be0a1f2292b67a038de72" => :high_sierra
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
