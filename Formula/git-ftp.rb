class GitFtp < Formula
  desc "Git-powered FTP client"
  homepage "https://git-ftp.github.io/"
  url "https://github.com/git-ftp/git-ftp/archive/1.4.0.tar.gz"
  sha256 "080e9385a9470d70a5a2a569c6e7db814902ffed873a77bec9d0084bcbc3e054"
  revision 4
  head "https://github.com/git-ftp/git-ftp.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "1b204b572ece0c781babed606ed137e25b5d1ed37988ca6f6a1c9c9ef4d7343a" => :high_sierra
    sha256 "62c93c15a1979e23eba20dd8a265b428c043f2a9d4c0c47370ff943b01b8a433" => :sierra
    sha256 "98d5acff82c7a3bff144f2d3110b8c9538390afc31562357a5118d068b059f33" => :el_capitan
  end

  depends_on "pandoc" => :build
  depends_on "libssh2"

  resource "curl" do
    url "https://curl.haxx.se/download/curl-7.58.0.tar.bz2"
    mirror "https://curl.askapache.com/download/curl-7.58.0.tar.bz2"
    sha256 "1cb081f97807c01e3ed747b6e1c9fee7a01cb10048f1cd0b5f56cfe0209de731"
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
