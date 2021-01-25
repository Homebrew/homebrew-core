class Hblock < Formula
  desc "Adblocker that creates a hosts file from multiple sources"
  homepage "https://hblock.molinero.dev/"
  url "https://github.com/hectorm/hblock/archive/v3.2.0.tar.gz"
  sha256 "a5a86a0e9913d88dcba7270c9e3ed37f4c626c8a6a8b5e9303a8a173824bdfee"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "8752ac1c6b5d9a16197c952cab95d0ed0f7259db9f98738471b679434ea533e6" => :big_sur
    sha256 "07cf3cb10349f9afbd7adb36ae2f4c7e3444ec9fc4c6bcfb5cd65c77488eaabd" => :arm64_big_sur
    sha256 "4599d523e51403bc471db40003a8c340d261acda6ed2b5eb26f92d5800aeec68" => :catalina
    sha256 "1a04f7ac7b843758d8fd74b9885f6bd608c28fffd2c127904515922720c6b360" => :mojave
  end

  uses_from_macos "curl"

  def install
    system "make", "install", "prefix=#{prefix}", "bindir=#{bin}", "mandir=#{man}"
  end

  test do
    output = shell_output("#{bin}/hblock -H none -F none -S none -A none -D none -qO-")
    assert_match "Blocked domains:", output
  end
end
