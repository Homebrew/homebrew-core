class Cgo < Formula
  desc "A terminal based gopher client"
  homepage "https://github.com/kieselsteini/cgo"
  url "https://github.com/kieselsteini/cgo/archive/c1ed336.zip"
  version "0.4.1"
  sha256 "f644ed2a40347d5d8567ef3d43c8c1da76ed251b71ddb34c576efa3b55782d13"

  depends_on "telnet"=> :optional
  depends_on "mplayer" => :optional

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/cgo", "-v"
  end
end
