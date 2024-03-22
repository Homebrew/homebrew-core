class Dcled < Formula
  desc "Linux driver for dream cheeky USB message board"
  homepage "https://www.jeffrika.com/~malakai/dcled/index.html"
  url "https://www.jeffrika.com/~malakai/dcled/dcled-2.2.tgz"
  sha256 "0da78c04e1aa42d16fa3df985cf54b0fbadf2d8ff338b9bf59bfe103c2a959c6"

  livecheck do
    url :homepage
    regex(/href=.*?dcled[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4ac7c81b9155f3196eccb25a230494545976a8570e91fe9c5e6544e5e860be92"
    sha256 cellar: :any,                 arm64_monterey: "338db9a99977a15fec8a4e2c2bf4432150c21e13e570c1caa852b99a689a9b3b"
    sha256 cellar: :any,                 arm64_big_sur:  "bd8fb1848c3296e5eaadf1436f891a2a6ab8142135947a2806db1d2e5212695d"
    sha256 cellar: :any,                 ventura:        "42bb46504f3936e2e6698f4a7da7e7de0db98a2edb55fa83ce91ff8c238c1cbd"
    sha256 cellar: :any,                 monterey:       "65cd5df08d1292e7f046bcada635cfd63708fcf75f7cc4e9f23b3bb402e0bbc1"
    sha256 cellar: :any,                 big_sur:        "5c36acee3c790871237cb7a3400c6fe4e37daa90258c10b89043ac2aad3a6dc4"
    sha256 cellar: :any,                 catalina:       "83a87a0f780dc73c21151690f3b1d0654d33e2baad358122be9d24a0610cea64"
    sha256 cellar: :any,                 mojave:         "4b94dd5ba218e3bdb0a10767d0ae62205495130baa839db4be4ab29d6561e5e2"
    sha256 cellar: :any,                 high_sierra:    "91cf7fa30d905efaf7499f0667c65e25ddb69d82be3f52b93d1df6a400fd7141"
    sha256 cellar: :any,                 sierra:         "bfc1532d76b4d37c706d065bc98feb5a3aeff20751a713d7b7efb08c0976fe9e"
    sha256 cellar: :any,                 el_capitan:     "53d07c9548eaeba12645e944ce92c27a02667758176815220dc4ee2a8945c661"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0c7a6b33e48eb8e369235f0bd1e84d10c161a41eaec0ab93854bec94df8aee0"
  end

  depends_on "libusb"

  def install
    system "make", "CC=#{ENV.cc}",
                   "LIBUSB_CFLAGS=-I#{Formula["libusb"].opt_include}/libusb-1.0"
    system "make", "install",
                   "FONTDIR=#{share}/#{name}",
                   "INSTALLDIR=#{bin}"
  end

  test do
    system "#{bin}/dcled", "--help"
  end
end
