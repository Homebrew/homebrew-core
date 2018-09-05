class GitFtp < Formula
  desc "Git-powered FTP client"
  homepage "https://git-ftp.github.io/"
  url "https://github.com/git-ftp/git-ftp/archive/1.5.1.tar.gz"
  sha256 "8cca25e1f718b987ea22ec05c7d72522f21cacedd00a8a0e827f87cd68e101f0"
  revision 3
  head "https://github.com/git-ftp/git-ftp.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "84f29a018ee316932280bab35e83ac6c68038dce7b22ba1ca8ac723ec9cfcefd" => :mojave
    sha256 "ee4eabc2531accda8c1177adc825d767a574ca33d73e929ef18e35be8102f1b1" => :high_sierra
    sha256 "a554272431c3e8cc448d222c005e6eefbcbedf3683138fc0f0a0d686a3c6ef71" => :sierra
    sha256 "863a4a3c5790f5fee6b992b15e5b4413e0c97846394b4ea2b0853d218ead22c6" => :el_capitan
  end

  depends_on "pandoc" => :build
  depends_on "libssh2"

  resource "curl" do
    url "https://curl.haxx.se/download/curl-7.61.1.tar.bz2"
    mirror "https://curl.askapache.com/download/curl-7.61.1.tar.bz2"
    sha256 "a308377dbc9a16b2e994abd55455e5f9edca4e31666f8f8fcfe7a1a4aea419b9"
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
