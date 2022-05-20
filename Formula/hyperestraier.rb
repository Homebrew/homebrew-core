class Hyperestraier < Formula
  desc "Full-text search system for communities"
  homepage "https://dbmx.net/hyperestraier/"
  url "https://dbmx.net/hyperestraier/hyperestraier-1.4.13.tar.gz"
  sha256 "496f21190fa0e0d8c29da4fd22cf5a2ce0c4a1d0bd34ef70f9ec66ff5fbf63e2"
  license "LGPL-2.1"

  livecheck do
    url :homepage
    regex(/href=.*?hyperestraier[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 monterey:     "e97a30177dd2112ae7ef36b2165213874faa7a4ef1e40dd6433ccfdd3eae7ac2"
    sha256 cellar: :any,                 big_sur:      "98338e8f67c7cba1df436607f09415415e39a38f695805ddd94720326eae9212"
    sha256 cellar: :any,                 catalina:     "0304cb2db3ed4e35c12ccaac0251ea19f7fd4c0f2a5b9f3ffad0f201f7f4357c"
    sha256 cellar: :any,                 mojave:       "4275d3ad552f225c5b686532d6cc2703481284fa73eaf3c5b35bc5551dc95761"
    sha256 cellar: :any,                 high_sierra:  "f0eeb8e60dc0639fdbf5c15fc22c954a627b5136525021706876972b5bfdd816"
    sha256 cellar: :any,                 sierra:       "c6018d888e9a4f03546f1727d9ec7b6d7eb6a87fc4f6755667bdafa71929aca7"
    sha256 cellar: :any,                 el_capitan:   "c90ef2d3ccac1af3247726697be33748ec53df85a98af4611b6dbfc9a8dca0c7"
    sha256 cellar: :any,                 yosemite:     "d18c19a9d691e2bd209cc05006b608776066352d297865238cc7262a527a82bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "67da1265df5336838e42f563b8b90041d83d848739bf7972950de444cef78650"
  end

  depends_on "qdbm"

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}",
                          "--disable-dependency-tracking"
    if OS.mac?
      system "make", "mac"
      system "make", "check-mac"
      system "make", "install-mac"
    else
      system "make", "LIBS=-lqdbm -lm"
      system "make", "check"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/estcmd", "version"
  end
end
