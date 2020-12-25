class CargoWatch < Formula
  desc "Watches over your Cargo project's source"
  homepage "https://github.com/passcod/cargo-watch"
  url "https://github.com/passcod/cargo-watch/archive/v7.5.0.tar.gz"
  sha256 "0d26b2c714f8e02ae4c7a1c4f87496e979694ab7847d3b74959c0d15c92f70ef"
  license "CC0-1.0"
  head "https://github.com/passcod/cargo-watch.git"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/cargo-watch -x build 2>&1", 1)
    assert_match "error: Not a Cargo project, aborting.", output

    assert_equal "cargo-watch #{version}", shell_output("#{bin}/cargo-watch --version").strip
  end
end
