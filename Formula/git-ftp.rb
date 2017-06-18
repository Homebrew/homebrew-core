class GitFtp < Formula
  desc "Git-powered FTP client"
  homepage "https://git-ftp.github.io/git-ftp"
  url "https://github.com/git-ftp/git-ftp/archive/1.4.0.tar.gz"
  sha256 "080e9385a9470d70a5a2a569c6e7db814902ffed873a77bec9d0084bcbc3e054"
  head "https://github.com/git-ftp/git-ftp.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "7c15fc59bcde7f29f12b918f2abf62ff5a20675010ba384ba9a257f474c3c714" => :sierra
    sha256 "7c15fc59bcde7f29f12b918f2abf62ff5a20675010ba384ba9a257f474c3c714" => :el_capitan
    sha256 "7c15fc59bcde7f29f12b918f2abf62ff5a20675010ba384ba9a257f474c3c714" => :yosemite
  end

  depends_on "pandoc" => :build
  depends_on "libssh2"

  resource "curl" do
    url "https://curl.haxx.se/download/curl-7.54.1.tar.bz2"
    mirror "http://curl.askapache.com/download/curl-7.54.1.tar.bz2"
    sha256 "fdfc4df2d001ee0c44ec071186e770046249263c491fcae48df0e1a3ca8f25a0"
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
