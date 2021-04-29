class CargoWatch < Formula
  desc "Watches over your Cargo project's source"
  homepage "https://github.com/passcod/cargo-watch"
  url "https://github.com/passcod/cargo-watch/archive/v7.7.1.tar.gz"
  sha256 "164c4b3ed6106dce6efbbd04a33010e880032cf3e650fd3b0098221974bfc74d"
  license "CC0-1.0"
  head "https://github.com/passcod/cargo-watch.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1465ac76dc15a324f13cabaa4435969339615ea8fe000e61fb6d61ffca3275f4"
    sha256 cellar: :any_skip_relocation, big_sur:       "61c87de1da37f50d870fabafddb327a5bc9e776ad919d98a8994ba4f32327179"
    sha256 cellar: :any_skip_relocation, catalina:      "095f06d964109f1f61e6e0ce645c2557672d30fdc017a9a64c11c0010036b4b1"
    sha256 cellar: :any_skip_relocation, mojave:        "ad447507c7a11bc607c0c962e51010c2348e96ec098d08d6b9bdd79a13d3350d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/cargo-watch -x build 2>&1", 1)
    assert_match "error: failed to start `cargo metadata`", output

    assert_equal "cargo-watch #{version}", shell_output("#{bin}/cargo-watch --version").strip
  end
end
