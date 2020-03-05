class GitFtp < Formula
  desc "Git-powered FTP client"
  homepage "https://git-ftp.github.io/"
  url "https://github.com/git-ftp/git-ftp/archive/1.6.0.tar.gz"
  sha256 "088b58d66c420e5eddc51327caec8dcbe8bddae557c308aa739231ed0490db01"
  head "https://github.com/git-ftp/git-ftp.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "0a61ca11e69370dfecfd3c82d6d03aeec377bf9db660658403556ea71b84bae0" => :catalina
    sha256 "f878c4015697794bb8b2c3f034a167b750d3871c0d320d903536128f01880ca2" => :mojave
    sha256 "63c8b94fd89eb635d8c2056efdf933de45dca7fdb04793b620750f8b338fbb88" => :high_sierra
  end

  depends_on "pandoc" => :build
  depends_on "libssh2"

  uses_from_macos "zlib"

  resource "curl" do
    url "https://curl.haxx.se/download/curl-7.69.0.tar.bz2"
    mirror "https://curl.askapache.com/download/curl-7.69.0.tar.bz2"
    sha256 "668d451108a7316cff040b23c79bc766e7ed84122074e44f662b8982f2e76739"
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
