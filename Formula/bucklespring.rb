class Bucklespring < Formula
  desc "Nostalgia bucklespring keyboard sound"
  homepage "https://github.com/zevv/bucklespring"
  url "https://github.com/zevv/bucklespring/archive/v1.4.0.tar.gz"
  sha256 "b38b2c0ec905573a243cb9db543f8eeb92e4d040025ef338d8bcfcfd5ccd5348"
  license "GPL-2.0-only"

  depends_on "alure"
  depends_on "pkg-config" => :build

  def install
    inreplace "Makefile", "-Wall -Werror", "-Wall"
    cp Dir[HOMEBREW_PREFIX/"lib/pkgconfig/alure.pc"], "mac/lib/pkgconfig/"
    ENV["PATH_AUDIO"] = "#{prefix}/wav"
    system "make"
    bin.install "buckle"
    prefix.install "wav"
  end

  test do
    system "buckle", "-h"
  end
end
