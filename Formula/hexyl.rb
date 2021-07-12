class Hexyl < Formula
  desc "Command-line hex viewer"
  homepage "https://github.com/sharkdp/hexyl"
  url "https://github.com/sharkdp/hexyl/archive/v0.9.0.tar.gz"
  sha256 "73f0dc1be1eaa1a34e3280bc1eeb4f86f34b024205fc7bf3c87d5a0bc4021a6a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "80188fd9d00fe87481bce6ba29cfd3e844f742d4978f4ebd11c61932c0adc245"
    sha256 cellar: :any_skip_relocation, big_sur:       "bba889ef6dae61053f47c70868cf511515e93e6157c3f232b60e879a293ead92"
    sha256 cellar: :any_skip_relocation, catalina:      "2443b91247ef98143863f23724ab1ffe3b192aa65471d2198ab02ffa72936ce9"
    sha256 cellar: :any_skip_relocation, mojave:        "465474b8dd2b6344efda4d611341a0d40c46965fabce4e3446bb3bc0a45c2392"
    sha256 cellar: :any_skip_relocation, high_sierra:   "8805fb02b8cc13ffe9ca11663140f502dfbcbe5a4cbdf1262bd88758bc88167f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02378c0a71d82ac24a4b6897d58532207e75e084e1bc754a3becf4ac15ce269f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    pdf = test_fixtures("test.pdf")
    output = shell_output("#{bin}/hexyl -n 100 #{pdf}")
    assert_match "00000000", output
  end
end
