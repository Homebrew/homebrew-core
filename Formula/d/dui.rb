class Dui < Formula
  desc "An intuitive Docker management CLI built in Rust"
  homepage "https://github.com/ukhan1219/dui"
  url "https://github.com/ukhan1219/dui/archive/refs/tags/v4.0.10.tar.gz"
  sha256 "eaf450e7ffe00f0e81482e9ec5c23afc4aa15ffeac2aa81acc837ac2a7e89e80"
  license "MIT"
  head "https://github.com/ukhan1219/dui.git", branch: "main"

  depends_on "rust" => :build

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Test that the binary works and provides help
    assert_match "USAGE:", shell_output("#{bin}/dui --help")
    
    # Test that it can list containers (even if none exist)
    assert_match "containers", shell_output("#{bin}/dui containers --help")
  end
end

