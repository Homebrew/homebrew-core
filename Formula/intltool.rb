class Intltool < Formula
  desc "String tool"
  homepage "https://wiki.freedesktop.org/www/Software/intltool"
  url "https://launchpad.net/intltool/trunk/0.51.0/+download/intltool-0.51.0.tar.gz"
  sha256 "67c74d94196b153b774ab9f89b2fa6c6ba79352407037c8c14d5aeb334e959cd"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "273d2b13868310fda429c3fbf1ddc347de0cab3189bf47639fd6c64adb8ec0cb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a95b3272a26918e1a92ad548ca72e1b74f5ade8073193c560c418369f9dacb51"
    sha256 cellar: :any_skip_relocation, monterey:       "bdeafd2b872e89587ccc884208d5ba41ef1ab5131ec6c508039d5f299b753c49"
    sha256 cellar: :any_skip_relocation, big_sur:        "aacf573a663f8c555bfa8163593386046462856392001b9dcad317fcf889fdfe"
    sha256 cellar: :any_skip_relocation, catalina:       "853b0f355c1bb6bdfc41d2ad17026d75c93aecb7581e711d7db3edab4ca6b5d4"
    sha256 cellar: :any_skip_relocation, mojave:         "52ccb5bfce1cda123f30c84335172335cee0706973e6769ec9a5358cb160f364"
    sha256 cellar: :any_skip_relocation, high_sierra:    "7924c9c7dc7b3eee0056171df8c6b66c2e0e8888e4638232e967a5ea31ca5b86"
    sha256 cellar: :any_skip_relocation, sierra:         "e587e46b6ebdebb7864eb4f9cb17c221024d9167ae0148899adedb6127b2bdfb"
    sha256 cellar: :any_skip_relocation, el_capitan:     "14bb0680842b8b392cb1a5f5baf142e99a54a538d1a587f6d1158785b276ffc6"
    sha256 cellar: :any_skip_relocation, yosemite:       "da6c24f1cc40fdf6ae286ec003ecd779d0f866fe850e36f5e5953786fa45a561"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9506dfd59eb01b9cd5735dde05523feded67cc2fc039053704dbbd46e02a49f8"
  end

  on_linux do
    depends_on "expat"
    depends_on "perl"

    resource "XML::Parser" do
      url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/XML-Parser-2.44.tar.gz"
      sha256 "1ae9d07ee9c35326b3d9aad56eae71a6730a73a116b9fe9e8a4758b7cc033216"
    end
  end

  def install
    if OS.linux?
      ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
      resources.each do |res|
        res.stage do
          system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
          system "make", "PERL5LIB=#{ENV["PERL5LIB"]}"
          system "make", "install"
        end
      end
    end

    system "./configure", "--prefix=#{prefix}",
                          "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system bin/"intltool-extract", "--help"
  end
end
