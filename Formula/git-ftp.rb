class GitFtp < Formula
  desc "Git-powered FTP client"
  homepage "https://git-ftp.github.io/"
  url "https://github.com/git-ftp/git-ftp/archive/1.5.2.tar.gz"
  sha256 "a6bf52f6f1d30c4d8f52fd0fbd61dc9f32e66099e3e9c4994bec65094305605b"
  head "https://github.com/git-ftp/git-ftp.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "37a19b4e3a957bd80143591d242cb17554cc40930c99ebb6f7a43f9446290dd2" => :mojave
    sha256 "67f3da9893b3df734502c349004dbef137bc490a860d75630ff2576b2362ff0b" => :high_sierra
    sha256 "6e0e4282c7ca692ad99675cdc2db8365d59c0aac5f8381f3e0ef064077703d7b" => :sierra
  end

  depends_on "pandoc" => :build
  depends_on "libssh2"
  uses_from_macos "zlib"

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
