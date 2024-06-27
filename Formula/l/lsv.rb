class Lsv < Formula
  desc "Vlang implementation of ls"
  homepage "https://mike-ward.net/lsv/"
  url "https://github.com/mike-ward/lsv/releases/download/2024.2/lsv_mac_m1.zip"
  sha256 "c739bbbb2fbe4603e083bc3969236ddff45835639c4ccfa3ef406bb18bca856d"
  license "MIT"

  def install
    bin.install "lsv"
  end

  test do
    assert_equal "lsv 2024.2", shell_output("#{bin}/lsv --version").strip
  end
end
