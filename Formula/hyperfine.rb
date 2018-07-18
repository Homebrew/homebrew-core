class Hyperfine < Formula
  desc "Command-line benchmarking tool"
  homepage "https://github.com/sharkdp/hyperfine"
  url "https://github.com/sharkdp/hyperfine/archive/v1.1.0.tar.gz"
  sha256 "2922bfd7128d8bac329eb73672dafc008bfb3bb01f94b81958f4d26a85d8a2cf"

  bottle do
    sha256 "0a3b5f88912fcf91ea254097d15bf6e8b4d6ec41aeb89b79280e8a95d9dc4093" => :high_sierra
    sha256 "0c93a7b1fd86aa3ccdf4c9eca7adc1205d4c2b63c11a40312a9e580ed590d230" => :sierra
    sha256 "bd8ac6ece5f7e519dbeac177b60b3900e22582fda5d047dd3d3987997eabe318" => :el_capitan
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix
  end

  test do
    output = shell_output("#{bin}/hyperfine 'sleep 0.3'")
    assert_match "Benchmark #1: sleep", output
  end
end
