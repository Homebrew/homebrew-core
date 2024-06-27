class Lsv < Formula
  desc "Vlang implementation of ls"
  homepage "https://mike-ward.net/lsv/"
  url "https://github.com/mike-ward/lsv/releases/download/2024.2/lsv_max_m1.gz"
  sha256 "af743cfb64afa597ba62c646d382fdcf82ff0daea9bed8cf80a69879fcff54e6"
  license "MIT"

  def install
    bin.install "lsv"
  end

  test do
    assert_equal "lsv 2024.2", shell_output("#{bin}/lsv --version").strip
  end
end
