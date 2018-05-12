class GitFtp < Formula
  desc "Git-powered FTP client"
  homepage "https://git-ftp.github.io/"
  url "https://github.com/git-ftp/git-ftp/archive/1.5.0.tar.gz"
  sha256 "6af31d8d6c8b72db8cbd94678fa6d38e83269c72e9d8a8200ba3335320fc7d49"
  head "https://github.com/git-ftp/git-ftp.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "4566d4e89b071b1c01f22302ae6c01e1758499cc3d730003f6bd704d9340985a" => :high_sierra
    sha256 "abd5ed32c6c203b2a0d479e7960f76c0b23e95aef4c0d62fa863225d63c5cc28" => :sierra
    sha256 "2d176762170b81769c3c43aa08975824e45feb6af91115e07d4245cd6631bbc1" => :el_capitan
  end

  depends_on "pandoc" => :build
  depends_on "libssh2"

  resource "curl" do
    url "https://curl.haxx.se/download/curl-7.59.0.tar.bz2"
    mirror "https://curl.askapache.com/download/curl-7.59.0.tar.bz2"
    sha256 "b5920ffd6a8c95585fb95070e0ced38322790cb335c39d0dab852d12e157b5a0"
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
