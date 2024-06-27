class Lsv < Formula
  desc "Vlang implementation of ls"
  homepage "https://mike-ward.net/lsv/"
  url "https://github.com/mike-ward/lsv/releases/download/2024.2/lsv_mac_m1.zip"
  sha256 "904fe34bd9f725098066f5716b9e1997da81cffec80f34e0195ffc9f131f24ff"
  license "MIT"

  def install
    bin.install "lsv"
  end

  test do
    assert_equal "lsv 2024.2", shell_output("#{bin}/lsv --version").strip
  end
end
