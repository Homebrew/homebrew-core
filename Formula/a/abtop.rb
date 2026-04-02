class Abtop < Formula
  desc "AI agent monitor for your terminal"
  homepage "https://github.com/graykode/abtop"
  url "https://github.com/graykode/abtop/archive/refs/tags/v0.2.7.tar.gz"
  sha256 "e2526c66e8bdfe25aa69173d528a9361b6badde4a5252eab1d32bed3ba952f5b"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "abtop #{version}", shell_output("#{bin}/abtop --version")
  end
end
