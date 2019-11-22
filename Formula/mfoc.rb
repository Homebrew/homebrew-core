class Mfoc < Formula
  desc "Implementation of 'offline nested' attack by Nethemba"
  homepage "https://github.com/nfc-tools/mfoc"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/mfoc/mfoc-0.10.7.tar.bz2"
  sha256 "93d8ac4cb0aa6ed94855ca9732a2ffd898a9095c087f12f9402205443c2eb98c"

  bottle do
    cellar :any
    sha256 "ae0c48b0627ab98e77eb92b35be2fc049cb7fdf39da9cec82c03342c09d8d852" => :catalina
    sha256 "5a4fe631caec6c2070b408158048c9d5976da9aa0fc8f1e60bd43dc64616db39" => :mojave
    sha256 "854390fb4717577ae0cfa33cffc50c0d5d568f23b28401aee6c81661b12dede4" => :high_sierra
    sha256 "be07709faf874fb9b9457950201a71b5f683f7971f2a3a7d61de630f78a2e69c" => :sierra
    sha256 "d895fdd47221e48e45f6858a1dc1c39c79ae743419b93ec4dfce84baa80af0a9" => :el_capitan
    sha256 "931fb4f22e9b02e40b4f1f28210df4a994a12efbd746bd7644d99a02837dbfda" => :yosemite
    sha256 "ecbf3f20c620ad022ab253ed68bc0005ee05c1fcc9eb178d6cc33bdf34f4515a" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "libnfc"
  depends_on "libusb"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"mfoc", "-h"
  end
end
