class Intltool < Formula
  desc "String tool"
  homepage "https://wiki.freedesktop.org/www/Software/intltool"
  url "https://launchpad.net/intltool/trunk/0.51.0/+download/intltool-0.51.0.tar.gz"
  sha256 "67c74d94196b153b774ab9f89b2fa6c6ba79352407037c8c14d5aeb334e959cd"
  license "GPL-2.0-or-later"
  revision 2

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "825910e5988270e48c5815bf1775a487d7b480c75a3128c1e800757a291119bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "825910e5988270e48c5815bf1775a487d7b480c75a3128c1e800757a291119bb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "825910e5988270e48c5815bf1775a487d7b480c75a3128c1e800757a291119bb"
    sha256 cellar: :any_skip_relocation, sonoma:         "286e3280e2bc6181262ce5052b7ece0ff083025baca2bfffff017af97df1bb34"
    sha256 cellar: :any_skip_relocation, ventura:        "286e3280e2bc6181262ce5052b7ece0ff083025baca2bfffff017af97df1bb34"
    sha256 cellar: :any_skip_relocation, monterey:       "286e3280e2bc6181262ce5052b7ece0ff083025baca2bfffff017af97df1bb34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "678c737197a0c2f6da3473c3d9a2e3227579d1399b392b34cb42086be4338bc6"
  end

  uses_from_macos "perl"

  on_linux do
    depends_on "expat"
    depends_on "perl-xml-parser"
  end

  def install
    if OS.linux?
      ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
      ENV.prepend_path "PERL5LIB", Formula["perl-xml-parser"].opt_libexec/"lib/perl5"
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
