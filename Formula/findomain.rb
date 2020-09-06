class Findomain < Formula
  desc "Cross-platform subdomain enumerator"
  homepage "https://github.com/Edu4rdSHL/findomain"
  url "https://github.com/Edu4rdSHL/findomain/archive/2.1.3.tar.gz"
  sha256 "3decbc3444165276608a68001db1a9d5f7a11470f850abe29f79e2e297026a79"
  license "GPL-3.0-or-later"

  bottle do
    cellar :any_skip_relocation
    sha256 "2393327e7a0bfbc144b318a38c806fd835bb37180cf3c24bc070bf80ae60cb18" => :catalina
    sha256 "a56a899fc78327428973d2ee267efed66ef04c401437041b2a451a4595294fdf" => :mojave
    sha256 "57447f5f3ecea975378a3d18699e700c47b5637a53e7e0a5401bd37ec9cbbddc" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Good luck Hax0r", shell_output("#{bin}/findomain -t brew.sh")
  end
end
