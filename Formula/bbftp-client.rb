class BbftpClient < Formula
  desc "Secure file transfer software, optimized for large files"
  homepage "https://software.in2p3.fr/bbftp/"
  url "http://software.in2p3.fr/bbftp/dist/bbftp-client-3.2.1.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/bbftp-client-3.2.1.tar.gz"
  sha256 "4000009804d90926ad3c0e770099874084fb49013e8b0770b82678462304456d"
  revision 3

  livecheck do
    url "http://software.in2p3.fr/bbftp/download.html"
    regex(/href=.*?bbftp-client[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "f30650734e1829a0c399153c78088ccd987f28ede25b8eb13ecde6b138d55076" => :big_sur
    sha256 "bd7a47c27111d4dc064a7009f919a3283360738329dcfde7eb6522ee280e78fd" => :arm64_big_sur
    sha256 "6d5bed31d69a0ff2f38f2642176cb3c3a4da34c4ea2740567d2698ca62519b7d" => :catalina
    sha256 "bdb7c899dab18816b4cc1d573291ba4691f365c9ed1c9951e73f9225810a8557" => :mojave
  end

  def install
    # Fix ntohll errors; reported 14 Jan 2015.
    ENV.append_to_cflags "-DHAVE_NTOHLL"

    cd "bbftpc" do
      system "./configure", "--disable-debug",
                            "--disable-dependency-tracking",
                            "--without-ssl",
                            "--prefix=#{prefix}"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/bbftp", "-v"
  end
end
