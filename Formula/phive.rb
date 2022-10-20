class Phive < Formula
  desc "Phar Installation and Verification Environment (PHIVE)"
  homepage "https://phar.io"
  url "https://github.com/phar-io/phive/releases/download/0.15.2/phive-0.15.2.phar"
  sha256 "2bb076753ec5d672f5e2f96a97a0fe7e8e9ec24a439eed00fd29ef942c7905f9"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2c22851c92782370a5cd51ce8f605dc6ba3bb910619ab6087e93e2fa3878adb9"
  end

  depends_on "php"

  def install
    bin.install "phive-#{version}.phar" => "phive"
  end

  test do
    assert_match "No PHARs configured for this project", shell_output("#{bin}/phive status")
  end
end
