class Phive < Formula
  desc "The Phar Installation and Verification Environment (PHIVE)"
  homepage "https://phar.io"
  url "https://github.com/phar-io/phive/releases/download/0.12.1/phive-0.12.1.phar"
  sha256 "6e39a2764b11e6823fa27c637b263e83d02929661a4f230b1b57dae35c6c6f30"

  bottle :unneeded

  depends_on "php" => :test

  def install
    bin.install "phive-#{version}.phar" => "phive"
  end

  test do
    assert_match /PHARs configured in phive.xml/, shell_output("#{bin}/phive status")
  end
end
