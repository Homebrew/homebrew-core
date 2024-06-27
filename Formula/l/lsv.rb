class Lsv < Formula
  desc "Vlang implementation of ls"
  homepage "https://mike-ward.net/lsv/"
  url "https://github.com/mike-ward/lsv/releases/download/2024.2/lsv_mac_m1.gz"
  sha256 "4b7aae13db5e366bfb90a0a66ec38c59d6264b5194dd8221e8f78d0086c92cd3"
  license "MIT"

  def install
    bin.install "lsv"
  end

  test do
    assert_equal "lsv 2024.2", shell_output("#{bin}/lsv --version").strip
  end
end
