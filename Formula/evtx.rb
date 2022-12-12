class Evtx < Formula
  desc "Windows XML Event Log parser"
  homepage "https://github.com/omerbenamram/evtx"
  url "https://github.com/omerbenamram/evtx/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "910c6062696c8748256d6afc90983ef802026e291a241f376e1bd74352218620"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/omerbenamram/evtx.git", branch: "master"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "error: The following required arguments were not provided",
      shell_output("#{bin}/evtx_dump 2>&1", 2)
  end
end
