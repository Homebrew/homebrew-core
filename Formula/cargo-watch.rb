class CargoWatch < Formula
  desc "Watches over your Cargo project's source"
  homepage "https://github.com/passcod/cargo-watch"
  url "https://github.com/passcod/cargo-watch/archive/v7.7.2.tar.gz"
  sha256 "395d0ce648010394bc769f93eac521fe3dbf25c317c2c54c9b623b0f23027aac"
  license "CC0-1.0"
  head "https://github.com/passcod/cargo-watch.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0c5aefc936284a715c3b14e4e854963340ea3f2d6fa1a63809e09ad192678453"
    sha256 cellar: :any_skip_relocation, big_sur:       "2f4b3b4410a34806cd66b552d867ab34a4e7b1d5f0c9228952f934b6c757a224"
    sha256 cellar: :any_skip_relocation, catalina:      "5ff7e7f551f2920cd801d7dc61d19bcf17e547699130a631728112f680f2c72b"
    sha256 cellar: :any_skip_relocation, mojave:        "60941d8cdb17a93935050a4bbfe5142314a4958af1d871abb8b33445374a8af4"
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
