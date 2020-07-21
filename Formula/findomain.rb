class Findomain < Formula
  desc "Cross-platform subdomain enumerator"
  homepage "https://github.com/Edu4rdSHL/findomain"
  url "https://github.com/Edu4rdSHL/findomain/archive/2.0.0.tar.gz"
  sha256 "59b7cc8c4bb855c8c66c589cccea6768c1c52e48420c899a3841cf30f6e123f4"
  license "GPL-3.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "e03ae2f28f9af5d97a80f0a8d296fd547533eb45560585fcb75cd148407e0fa3" => :catalina
    sha256 "7ca35736e0a42a6db0fc6897501f58ad47a3d31e339540f4a2098028d94c8848" => :mojave
    sha256 "983fb6bc20678a699027b30648717102f0616a4866d1053e95430e112c6270a4" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Good luck Hax0r", shell_output("#{bin}/findomain -t brew.sh")
  end
end
