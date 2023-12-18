class HomebrewPortkill < Formula
  desc "Brew tab for killing ports"
  homepage "https://github.com/devasghar/homebrew-portkill"
  url "https://github.com/devasghar/homebrew-portkill/archive/refs/tags/0.0.7.tar.gz"
  sha256 "6c1125c8005de24317261592bb3cb1e09fe1845cefccee9ff5020ffd83dbbea5"
  license "MIT"

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
  end

  test do
    system "false"
  end
end
