class Dar < Formula
  desc "Backup directory tree and files"
  homepage "http://dar.linux.free.fr/doc/index.html"
  url "https://downloads.sourceforge.net/project/dar/dar/2.7.9/dar-2.7.9.tar.gz"
  sha256 "1c609f691f99e6a868c0a6fcf70d2f5d2adee5dc3c0cbf374e69983129677df5"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/dar[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256               arm64_ventura:  "7cbef1d93078441e341963f6d45f98b7548066e3c27c9ec864d8860a81f94a05"
    sha256               arm64_monterey: "0c3f050775bdb3802d0ca63e819f1d31794d6353e2daa3152a26eb4c26d33b53"
    sha256               arm64_big_sur:  "3acc199f9fdb2533766a853cc2397a60a79fd8781908748e1a81745fd995c4d1"
    sha256 cellar: :any, monterey:       "607115ea92bf853dcc42bb82ff5740ae2f921afec71a29f82382a4f34cb4eca2"
    sha256 cellar: :any, big_sur:        "cf7783da36b47a0bd54dfd8954c01f79b7b1f30eea8eee95f02a79edbba15d89"
    sha256 cellar: :any, catalina:       "2704638c041551e2f887ed52d5ddae588a5953e8c22ba3184750b51736ae2164"
    sha256               x86_64_linux:   "d662471b6c1d22bbb4388e8256e26d528eb34c4d8496ceb7e7ac1cc9e7078f99"
  end

  depends_on "libgcrypt"
  depends_on "lzo"

  uses_from_macos "zlib"

  on_intel do
    depends_on "upx" => :build
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-build-html",
                          "--disable-dar-static",
                          "--disable-dependency-tracking",
                          "--disable-libxz-linking",
                          "--enable-mode=64"
    system "make", "install"
  end

  test do
    system bin/"dar", "-c", "test", "-R", "./Library"
    system bin/"dar", "-d", "test", "-R", "./Library"
  end
end
