class Ip < Formula
  desc "ifconfig alternative showing external IP, active interfaces & internal IPv4 only."
  homepage "https://github.com/StarkChristmas/ipget"
  url "https://github.com/StarkChristmas/ipget/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "0f1e6099eb568f3027db981177a1062c84036171cb13b697c38c992a81339ba0"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./main.go"
  end

  test do
    output = shell_output("#{bin}/ip 2>&1")
    assert_match /\d+\.\d+\.\d+\.\d+/, output
  end
end
