class Dysk < Formula
  desc "Linux utility to get information on filesystems, like df but better"
  homepage "https://dystroy.org/dysk/"
  url "https://github.com/Canop/dysk/archive/refs/tags/v3.8.2.tar.gz"
  sha256 "3e82c5d1624bf30a8c71e56f879d7e1af85c1a0a957d7a47ffa1194dbc281ea3"
  license "MIT"
  head "https://github.com/Canop/dysk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "83e82aa6ab4373826caf36c691bdcbe8fd022211be5be2fc9a0ade35a0933877"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e104444d8211287af92577f4363743677cd37cee24a7fea044fb35fa559d56fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ed174398c2fee4ed7eac2d33f06d33efbb124b963209f350cc0251e28c8ca3d7"
    sha256 cellar: :any,                 arm64_linux:       "f8b9f0afa271d1c7b725f5da5972d5f6ea5438c4c48b25a2d6a2f7b808dd2139"
    sha256 cellar: :any,                 x86_64_linux:      "383e2296c3cf179a2e4feda492b3c8f52b4796f56d39289ef9cf8f4f4a8f7026"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "filesystem", shell_output("#{bin}/dysk -s free-d")
    assert_match version.to_s, shell_output("#{bin}/dysk --version")
  end
end
