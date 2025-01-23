class Dar < Formula
  desc "Backup directory tree and files"
  homepage "http://dar.linux.free.fr/doc/index.html"
  url "https://downloads.sourceforge.net/project/dar/dar/2.7.16/dar-2.7.16.tar.gz"
  sha256 "1aac0eab03602ccfa3696c2e1817c09665deee124da6c319d77f1ee1d641804d"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/dar[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sequoia: "fe08149cad8919cfcf79dc4e6a603963ea47048e96b6fc0c32c6dcc39d6e9cdf"
    sha256 arm64_sonoma:  "c6cd34bc8495ba6405ec1d8483426c6f9affc6706878f07dcae70e24b062875b"
    sha256 arm64_ventura: "d15d9e8e9ed1d7b9d569e6655106800612d6fd63fa8680baed3eb7bf7ef5caa7"
    sha256 sonoma:        "405f94e8feac3c42b4d3975a7693a65e32249a20a713765472fee003843b53dd"
    sha256 ventura:       "027bf33538192f67a38b0f1ebd27e21ae954e53e5795a1e8fef746349641278c"
    sha256 x86_64_linux:  "a93ac5969bfbfe78c2be10668b1c8c381d1b4e3cadb831f222e863cfbc644d62"
  end

  depends_on "argon2"
  depends_on "libgcrypt"
  depends_on "lzo"

  uses_from_macos "zlib"

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
    mkdir "Library"
    system bin/"dar", "-c", "test", "-R", "./Library"
    system bin/"dar", "-d", "test", "-R", "./Library"
  end
end
