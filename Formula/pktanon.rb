class Pktanon < Formula
  desc "Packet trace anonymization"
  homepage "https://www.tm.uka.de/software/pktanon/index.html"
  url "https://www.tm.uka.de/software/pktanon/download/pktanon-1.4.0-dev.tar.gz"
  sha256 "db3f437bcb8ddb40323ddef7a9de25a465c5f6b4cce078202060f661d4b97ba3"
  revision 2

  # The regex below matches development versions, as a stable version isn't yet
  # available. If stable versions appear in the future, we should modify the
  # regex to omit development versions (i.e., remove `(?:[._-]dev)?`).
  livecheck do
    url "https://www.tm.uka.de/software/pktanon/download/index.html"
    regex(/href=.*?pktanon[._-]v?(\d+(?:\.\d+)+)(?:[._-]dev)?\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "e853faa62dd62e2663e5d9b551e79cd492927baab2b472aca01d981a6ef7913c"
    sha256 cellar: :any, big_sur:       "53338eaa0e9e00d44d1084d7aee1aacfd498b568c5a145edc8da2da4b7054177"
    sha256 cellar: :any, catalina:      "a8509ba2a13056c218fca682edf990df133b67e2b471eb561aac0d49d446bc7e"
    sha256 cellar: :any, mojave:        "8d5bb1d5ac9f2cc9bcf73d45b22a0c724e42da26ac0dccc6c66c2e2a4e8a024d"
    sha256 cellar: :any, high_sierra:   "5a3c101ebf3a3bb948c6005977367da0f72fa17fe2ffc3c410b8428325a140f8"
    sha256 cellar: :any, sierra:        "20773e51330880065df3de1c5e80107f1f20cfe53c4735be80b39d9e1d0cca41"
  end

  depends_on "boost"
  depends_on "xerces-c"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    # fix compile failure caused by undefined function 'sleep'.
    inreplace "src/Timer.cpp", %Q(#include "Timer.h"\r\n),
      %Q(#include "Timer.h"\r\n#include "unistd.h"\r\n)

    # include the boost system library to resolve compilation errors
    ENV["LIBS"] = "-lboost_system-mt"

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/pktanon", "--version"
  end
end
