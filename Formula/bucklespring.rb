class Bucklespring < Formula
  desc "Nostalgia bucklespring keyboard sound"
  homepage "https://github.com/zevv/bucklespring"
  url "https://github.com/zevv/bucklespring/archive/v1.4.0.tar.gz"
  sha256 "b38b2c0ec905573a243cb9db543f8eeb92e4d040025ef338d8bcfcfd5ccd5348"
  license "GPL-2.0-only"

  depends_on "alure" => :build
  depends_on "pkg-config" => :build

  def install
    inreplace "Makefile", "-Wall -Werror", "-Wall"
    cp Formula["pkg-config"].opt_lib/"alure.pc", "mac/lib/pkgconfig/"
    system "PATH_AUDIO=#{prefix}/wav make"
    bin.install "buckle"
    prefix.install "wav"
  end

  test do
    system "buckle", "-h"
  end
end
