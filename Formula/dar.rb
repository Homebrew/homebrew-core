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
    sha256 arm64_ventura:  "2e1279a73d3d474c2e555d0b751bc2b9a3d477458acc7fb42e36949540b24aa9"
    sha256 arm64_monterey: "3d906d174e5bde0fc8bbab53c8783096b4a4e2887b5638a844565c1845bf8b92"
    sha256 arm64_big_sur:  "99411d919bd8f1005ebfe0b9ecace628485263f81ee687545a42b485c798c7e2"
    sha256 monterey:       "932c401475261bbf614062508b448fb5d7b3bc770a49a9236948b3cc8a8ec2a2"
    sha256 big_sur:        "9c82b987d80d5f503af0ff1d984852bbec241fd1871e3fcacd71c7bf9bff06e9"
  end

  depends_on "argon2"
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
