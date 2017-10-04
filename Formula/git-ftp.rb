class GitFtp < Formula
  desc "Git-powered FTP client"
  homepage "https://git-ftp.github.io/git-ftp"
  url "https://github.com/git-ftp/git-ftp/archive/1.4.0.tar.gz"
  sha256 "080e9385a9470d70a5a2a569c6e7db814902ffed873a77bec9d0084bcbc3e054"
  revision 1
  head "https://github.com/git-ftp/git-ftp.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "b81a38b356251b818ded806ea00d48ddf1686a4c6a2b907e1f3cc54dbfa233e3" => :high_sierra
    sha256 "7a4df7d587138c9513a3fe5058e0532ae91e84ddcb5182da214dcb911a5b9a31" => :sierra
    sha256 "a34ce84325e2d130058fbca3575422a4aceb48540664c2de2296c1d6308c6295" => :el_capitan
    sha256 "4fd1fc02d184902114cc01a38db5c206f859127a0d624def0456f8034a90495c" => :yosemite
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
