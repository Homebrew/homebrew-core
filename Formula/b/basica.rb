class Basica < Formula
  desc "Small IBM BASICA-compatible interpreter clone written in C"
  homepage "https://github.com/kdekorte/basica"
  url "https://github.com/kdekorte/basica/releases/download/v0.99.1/basica-0.99.1.zip"
  sha256 "88ca11c45835aaa0115d40e1edde5d9fcf13e4d04fd3436eb4981607d440d043"
  license "MIT"

  depends_on "pkg-config" => :build
  depends_on "sdl3"
  depends_on "sdl3_image"
  depends_on "sdl3_mixer"
  depends_on "sdl3_ttf"

  def install
    system "make", "CC=#{ENV.cc}", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match "BASICA", shell_output("#{bin}/basica --version")
  end
end
