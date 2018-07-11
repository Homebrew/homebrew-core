class GitFtp < Formula
  desc "Git-powered FTP client"
  homepage "https://git-ftp.github.io/"
  url "https://github.com/git-ftp/git-ftp/archive/1.5.1.tar.gz"
  sha256 "8cca25e1f718b987ea22ec05c7d72522f21cacedd00a8a0e827f87cd68e101f0"
  revision 2
  head "https://github.com/git-ftp/git-ftp.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "0ff2acffa0b98ffd12599040d7d3f7684c0cbf4252863897c7f1bd7d162a3127" => :high_sierra
    sha256 "8c3ae60cabd15bf7fe8f5d0e978cedb62f138617cdb291449970530cdce2eb7d" => :sierra
    sha256 "8d879558e0cba597e54565aa5c4a545c8657ee71032dbfd18425f46572ac661c" => :el_capitan
  end

  depends_on "pandoc" => :build
  depends_on "libssh2"

  resource "curl" do
    url "https://curl.haxx.se/download/curl-7.61.0.tar.bz2"
    mirror "https://curl.askapache.com/download/curl-7.61.0.tar.bz2"
    sha256 "5f6f336921cf5b84de56afbd08dfb70adeef2303751ffb3e570c936c6d656c9c"
  end

  def install
    resource("curl").stage do
      system "./configure", "--disable-debug",
                            "--disable-dependency-tracking",
                            "--disable-silent-rules",
                            "--prefix=#{libexec}",
                            "--disable-ares",
                            "--with-darwinssl",
                            "--with-libssh2",
                            "--without-brotli",
                            "--without-ca-bundle",
                            "--without-ca-path",
                            "--without-gssapi",
                            "--without-libmetalink",
                            "--without-librtmp"
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
