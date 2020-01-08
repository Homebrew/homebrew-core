class Hexyl < Formula
  desc "Command-line hex viewer"
  homepage "https://github.com/sharkdp/hexyl"
  url "https://github.com/sharkdp/hexyl/archive/v0.6.0.tar.gz"
  sha256 "5031b20c13b3ccb27abbf119b54609cef16c4152aca2823ee5c53cd5f434b97e"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "c3d573fa057aef06a57da5e5244c50d45e895b2a0ffe36f543efc04866074d6d" => :catalina
    sha256 "99a3133f73538f29f0dc2a603f122b2c2165fdd53de0f2141fc0ebab086c22f2" => :mojave
    sha256 "c1f885347631441fceeb3f0ed4d29dc4c259f36108da31ce862dc240c1884819" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    pdf = test_fixtures("test.pdf")
    output = shell_output("#{bin}/hexyl -n 100 #{pdf}")
    assert_match "00000000", output
  end
end
