class Lune < Formula
  desc "Standalone Luau script runtime"
  homepage "https://lune-org.github.io/docs"
  url "https://github.com/lune-org/lune/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "e98a00898c2573649d242d87b21af6cdeb5fd1c0fb5a9df53d9c18fc3c1c5008"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7e5e5b12fb64e3733d27a5e04087d1e4ed08872dcd52a6033e2615e648c20ee1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "141c3a8803c4f5675913346f747d7edb954aad0f8aed62a50f66d8b3601f0fe9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8eb836beab8318e41478fa72dd671d98f9f67b6d810892d22ea7ce093ad0c4dc"
    sha256 cellar: :any_skip_relocation, sonoma:         "febba79262a62d18dc6f20393e94e8fb6490d9c93d90f8e68205a907e49fcec9"
    sha256 cellar: :any_skip_relocation, ventura:        "5ec9e9cff005cc06e5683e89ddf3c241226a6146038605d1d2a14d8ee60d3f8d"
    sha256 cellar: :any_skip_relocation, monterey:       "607e6b5e62314e4829cb448c39a620309ad483f78f99c0efa853fd3a41a6f0bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "399fbd1c0f5a7615546c64e2f6cbafe4f9496060a9d22beb28bfaefe2c26166c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--all-features", *std_cargo_args
  end

  test do
    (testpath/"test.lua").write("print(2 + 2)")
    assert_equal "4", shell_output("#{bin}/lune run test.lua").chomp
  end
end
