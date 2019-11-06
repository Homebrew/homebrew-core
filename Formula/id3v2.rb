class Id3v2 < Formula
  desc "Command-line editor"
  homepage "https://id3v2.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/id3v2/id3v2/0.1.12/id3v2-0.1.12.tar.gz"
  sha256 "8105fad3189dbb0e4cb381862b4fa18744233c3bbe6def6f81ff64f5101722bf"

  bottle do
    cellar :any
    sha256 "2476bad339650dc2c12e3dd074b3aba7058e9b3b07c9caf05d6f068ea216d9ef" => :catalina
    sha256 "f0e2da49b513dce2ab73589b2aed98ae2cca184dbe082f92502d87e96ba9731d" => :mojave
    sha256 "ca2c1296318425931c5eec52c70adf98665edeb19d5b681271c3b6353ddf171a" => :high_sierra
    sha256 "3b1d75af49217a58f5ecb6f0e9e34564b299903898c76145218a6496de3a7778" => :sierra
    sha256 "941e267b5a214013c8085c7918c0d8c1805c906cacf162191b764d2ae1df265f" => :el_capitan
    sha256 "cd8dd2f943081a051214bf0eedb3c1431abf2bb060a528058e6b9d4c841995ce" => :yosemite
    sha256 "129381e13539c589fce554a305f4c0a83763ae01865f8810c4145089969c51db" => :mavericks
  end

  depends_on "id3lib"

  def install
    # tarball includes a prebuilt Linux binary, which will get installed
    # by `make install` if `make clean` isn't run first
    system "make", "clean"
    bin.mkpath
    man1.mkpath
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/id3v2", "--version"
  end
end
