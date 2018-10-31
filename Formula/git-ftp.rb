class GitFtp < Formula
  desc "Git-powered FTP client"
  homepage "https://git-ftp.github.io/"
  url "https://github.com/git-ftp/git-ftp/archive/1.5.1.tar.gz"
  sha256 "8cca25e1f718b987ea22ec05c7d72522f21cacedd00a8a0e827f87cd68e101f0"
  revision 3
  head "https://github.com/git-ftp/git-ftp.git", :branch => "develop"

  bottle do
    cellar :any
    rebuild 1
    sha256 "05d8eaa07ce02ca49b84b11452e0532e75ce32d7b8925ab25e942dedf22ca417" => :mojave
    sha256 "dec17745a52217c32716095cae029e9bfdc33767f05244d6376c1e31a0e3206f" => :high_sierra
    sha256 "68a9a026483d20a5dd9bf9e17200e4e9b91fdf1349618217fb43ee59648d5be6" => :sierra
  end

  depends_on "pandoc" => :build
  depends_on "libssh2"

  resource "curl" do
    url "https://curl.haxx.se/download/curl-7.62.0.tar.bz2"
    mirror "https://curl.askapache.com/download/curl-7.62.0.tar.bz2"
    sha256 "7802c54076500be500b171fde786258579d60547a3a35b8c5a23d8c88e8f9620"
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
