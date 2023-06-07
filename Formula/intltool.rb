class Intltool < Formula
  desc "String tool"
  homepage "https://wiki.freedesktop.org/www/Software/intltool"
  url "https://launchpad.net/intltool/trunk/0.51.0/+download/intltool-0.51.0.tar.gz"
  sha256 "67c74d94196b153b774ab9f89b2fa6c6ba79352407037c8c14d5aeb334e959cd"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "45adf17254203ae3085e595907a01e02188643a3080c595a0a9f50301ecd8e56"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45adf17254203ae3085e595907a01e02188643a3080c595a0a9f50301ecd8e56"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "45adf17254203ae3085e595907a01e02188643a3080c595a0a9f50301ecd8e56"
    sha256 cellar: :any_skip_relocation, ventura:        "743ff02675bf6a8b52311d8fb93ceff3ef512487d29940b547992e3e8f6e494e"
    sha256 cellar: :any_skip_relocation, monterey:       "743ff02675bf6a8b52311d8fb93ceff3ef512487d29940b547992e3e8f6e494e"
    sha256 cellar: :any_skip_relocation, big_sur:        "743ff02675bf6a8b52311d8fb93ceff3ef512487d29940b547992e3e8f6e494e"
    sha256 cellar: :any_skip_relocation, catalina:       "743ff02675bf6a8b52311d8fb93ceff3ef512487d29940b547992e3e8f6e494e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3250b9524cf8540d10b5354145fd3541c4c308efaaa091d17f6bd691a552b15b"
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
