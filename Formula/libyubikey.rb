class Libyubikey < Formula
  desc "C library for manipulating Yubico one-time passwords"
  homepage "https://yubico.github.io/yubico-c/"
  url "https://developers.yubico.com/yubico-c/Releases/libyubikey-1.13.tar.gz"
  sha256 "04edd0eb09cb665a05d808c58e1985f25bb7c5254d2849f36a0658ffc51c3401"

  bottle do
    cellar :any
    sha256 "f5f99ad5056fe1d8bfa69a389983ac9ae0f5e65c60d984de4fb9591b6b19daba" => :mojave
    sha256 "8440f766e153b537a092f55a07990c0fd28e0b244407bf6824d21fedb3d97f32" => :high_sierra
    sha256 "23f550d2f6e2cd6310756e3625c17868e206c90029e241fbc915a408f4761263" => :sierra
    sha256 "2b1fbc1860932dd4a4c2b09928d838bc3646ff0b2a97bc5c538981befdc21760" => :el_capitan
    sha256 "7f5c7a55b9e5bf373f01f8f02a983d45ae11d801acc8110cd8f5e13edf0e2973" => :yosemite
    sha256 "efaf65ea86cb01821d8c3145ab0f0528f6bb9e8afa0090ffbf2c0818e093c357" => :mavericks
    sha256 "53122ea8a869ed5c811273df1c2767e46138797f1af122db93beda2b7254b407" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
