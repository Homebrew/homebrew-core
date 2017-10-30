class GitFtp < Formula
  desc "Git-powered FTP client"
  homepage "https://git-ftp.github.io/git-ftp"
  url "https://github.com/git-ftp/git-ftp/archive/1.4.0.tar.gz"
  sha256 "080e9385a9470d70a5a2a569c6e7db814902ffed873a77bec9d0084bcbc3e054"
  revision 2
  head "https://github.com/git-ftp/git-ftp.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "fa0d16d4139471f5a1351aea7a6bf800217577e22d2e473ce3cb5808c9c41840" => :high_sierra
    sha256 "fe60f7ee5a11a90af9bb5535f4c7c264366084df7d5de42c5107e5f1b5277329" => :sierra
    sha256 "01af63718ea283e7bf5bf3b951bad6d2739e71441f7b58bb80918be99a25dcf3" => :el_capitan
  end

  depends_on "pandoc" => :build
  depends_on "libssh2"

  resource "curl" do
    url "https://curl.haxx.se/download/curl-7.56.1.tar.bz2"
    mirror "http://curl.askapache.com/download/curl-7.56.1.tar.bz2"
    sha256 "2594670367875e7d87b0f129b5e4690150780884d90244ba0fe3e74a778b5f90"
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
