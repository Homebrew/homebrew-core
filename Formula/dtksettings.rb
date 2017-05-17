class Dtksettings < Formula
  desc "Deepin Tool Kit Settings Module"
  homepage "https://www.deepin.org"
  url "http://packages.deepin.com/deepin/pool/main/d/dtksettings/dtksettings_0.1.5.orig.tar.xz"
  sha256 "8868bbf45cfc734bcd1c5071029f5ed509378be00133b62908a0f69e0879ecb7"

  depends_on "pkg-config" => :build
  depends_on "qt@5.7"

  def install
    system "qmake", "PREFIX=#{prefix}", "-r", "."
    system "make"
    system "make", "install"
  end

  test do
    system "true"
  end
end
