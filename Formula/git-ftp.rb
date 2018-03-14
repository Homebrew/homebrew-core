class GitFtp < Formula
  desc "Git-powered FTP client"
  homepage "https://git-ftp.github.io/"
  url "https://github.com/git-ftp/git-ftp/archive/1.4.0.tar.gz"
  sha256 "080e9385a9470d70a5a2a569c6e7db814902ffed873a77bec9d0084bcbc3e054"
  revision 5
  head "https://github.com/git-ftp/git-ftp.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "340aaf8dfffb1f693ef1d1f2a3f5ab02a47f045465be3309a64eb2050b8e65be" => :high_sierra
    sha256 "3cf29db89c0524385d18970de6e69eacc6a7c70a3a0f937a450022a236e9729f" => :sierra
    sha256 "4becd0c46b251a2e7435244f7bee51a01ecab1a1df210a5cef32f8635e6ea031" => :el_capitan
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
