class Nixpacks < Formula
  desc "App source + Nix packages + Docker = Image"
  homepage "https://nixpacks.com/"
  url "https://github.com/railwayapp/nixpacks/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "2bbd6ef1502fb41cd9cf91b0d3ee217de27886b13c958e04e849c3f661772d30"
  license "MIT"
  head "https://github.com/railwayapp/nixpacks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fbecb0dd085351d98ac1ea4e3f2fe80e6ab0257bd4ccb1b45d5948d9cfc63d7c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e612ca44fc8d57778cea22f808aeae7f04766df882e0f9b13e9af2348296538"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "faf08a7640d3cec33db856008c038d2d822765e3fe6329a92dbf99ae5203aaa4"
    sha256 cellar: :any_skip_relocation, sonoma:         "be73997bd3be23ea110453e89faff4aa4d5ddfe94999eb128a74002dd2eae94a"
    sha256 cellar: :any_skip_relocation, ventura:        "0587b19e3897a2bbf6a8fe35484837b9d4e73977ee7ec8a93eb538ecb487cea6"
    sha256 cellar: :any_skip_relocation, monterey:       "ab4c952b66d4a275c5debfe3f45d874a54dded9fbfdbd352f2edd05c28d3810b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa1a148d4c49a77818f02471c5aae69728bb1c8613829db459216b206ec35693"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/nixpacks build #{testpath} --name test", 1)
    assert_match "Nixpacks was unable to generate a build plan for this app", output

    assert_equal "nixpacks #{version}", shell_output("#{bin}/nixpacks -V").chomp
  end
end
