class GitFtp < Formula
  desc "Git-powered FTP client"
  homepage "https://git-ftp.github.io/git-ftp"
  url "https://github.com/git-ftp/git-ftp/archive/1.4.0.tar.gz"
  sha256 "080e9385a9470d70a5a2a569c6e7db814902ffed873a77bec9d0084bcbc3e054"
  revision 1
  head "https://github.com/git-ftp/git-ftp.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "3ecef63735ee7c7d534b5c427b4ef12c012f9ee3b37f6a3c9360ecfe5e90f3f9" => :high_sierra
    sha256 "9524c0db4b63cbfb1b50e5d00d6700b6d2433e8868231dd097f3442dd78e4613" => :sierra
    sha256 "a4d8198f88ed08173021c0292f430c2248dbede432f846eb052722ef8bd805c2" => :el_capitan
  end

  depends_on "pandoc" => :build
  depends_on "libssh2"

  resource "curl" do
    url "https://curl.haxx.se/download/curl-7.56.0.tar.bz2"
    mirror "http://curl.askapache.com/download/curl-7.56.0.tar.bz2"
    sha256 "de60a4725a3d461c70aa571d7d69c788f1816d9d1a8a2ef05f864ce8f01279df"
  end

  def install
    resource("curl").stage do
      system "./configure", "--disable-debug",
                            "--disable-dependency-tracking",
                            "--disable-silent-rules",
                            "--prefix=#{libexec}",
                            "--with-darwinssl",
                            "--without-ca-bundle",
                            "--without-ca-path",
                            "--with-libssh2",
                            "--without-libmetalink",
                            "--without-gssapi",
                            "--without-librtmp",
                            "--disable-ares"
      system "make", "install"
    end

    system "make", "prefix=#{prefix}", "install"
    system "make", "-C", "man", "man"
    man1.install "man/git-ftp.1"
    (libexec/"bin").install bin/"git-ftp"
    (bin/"git-ftp").write_env_script(libexec/"bin/git-ftp", :PATH => "#{libexec}/bin:$PATH")
  end

  test do
    system bin/"git-ftp", "--help"
  end
end
