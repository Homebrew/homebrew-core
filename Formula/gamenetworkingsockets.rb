class Gamenetworkingsockets < Formula
  desc "Reliable & unreliable messages over UDP"
  homepage "https://github.com/ValveSoftware/GameNetworkingSockets"
  head "https://github.com/ValveSoftware/GameNetworkingSockets.git"
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config"
  depends_on "protobuf"
  depends_on "openssl"

  def install
    mkdir "build" do
      system "meson", "--prefix=#{prefix}", "../src"
      system "ninja"
      system "ninja", "test"
      system "ninja", "install"
    end
  end
end
