class Abtop < Formula
  desc "AI agent monitor for your terminal"
  homepage "https://github.com/graykode/abtop"
  url "https://github.com/graykode/abtop/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "5cdf40f8ac36ee54c821f205e5a1e66c2b6c8a7690ff3b259461fb4758ba6c96"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "abtop", shell_output("#{bin}/abtop --once")
  end
end
