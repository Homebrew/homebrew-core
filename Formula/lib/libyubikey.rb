class Libyubikey < Formula
  desc "C library for manipulating Yubico one-time passwords"
  homepage "https://yubico.github.io/yubico-c/"
  url "https://developers.yubico.com/yubico-c/Releases/libyubikey-1.13.tar.gz"
  sha256 "04edd0eb09cb665a05d808c58e1985f25bb7c5254d2849f36a0658ffc51c3401"
  license "BSD-2-Clause"

  livecheck do
    url "https://developers.yubico.com/yubico-c/Releases/"
    regex(/href=.*?libyubikey[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4580266e70e2afadf36db6e307f1e2f5046e06628b1482d55c11af8714c9fd87"
    sha256 cellar: :any,                 arm64_monterey: "b1df3ed34996e203f862b623d96606645e25f564e8b2827539c4744c3712fd28"
    sha256 cellar: :any,                 arm64_big_sur:  "281fc4490bcdf4c4b19c5aa08a10a996e8fb10c9e1385ba95abd973186e18932"
    sha256 cellar: :any,                 ventura:        "4a3cef8d90a4771f8af5102c61544d8c2479333553fd2671ecf8faaf6bdb8388"
    sha256 cellar: :any,                 monterey:       "e698d9e14c769152fe36caa69cb4b0232747f76fd0b2e8cc02518dc42f758ff9"
    sha256 cellar: :any,                 big_sur:        "d8294cc5022aa96ca4d2073756da801daef11a07e3464656af749008b84cde6d"
    sha256 cellar: :any,                 catalina:       "b6fccb68ae85837533ea4680063cc64f207f2d6926c4eafaf23e81f0b790fc55"
    sha256 cellar: :any,                 mojave:         "f5f99ad5056fe1d8bfa69a389983ac9ae0f5e65c60d984de4fb9591b6b19daba"
    sha256 cellar: :any,                 high_sierra:    "8440f766e153b537a092f55a07990c0fd28e0b244407bf6824d21fedb3d97f32"
    sha256 cellar: :any,                 sierra:         "23f550d2f6e2cd6310756e3625c17868e206c90029e241fbc915a408f4761263"
    sha256 cellar: :any,                 el_capitan:     "2b1fbc1860932dd4a4c2b09928d838bc3646ff0b2a97bc5c538981befdc21760"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47be6e603ede5ef7fee2f40cfd4ac4338ca094d25b2a897388df4b90ca5101b7"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
