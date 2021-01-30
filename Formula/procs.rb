class Procs < Formula
  desc "Modern replacement for ps written by Rust"
  homepage "https://github.com/dalance/procs"
  url "https://github.com/dalance/procs/archive/v0.11.3.tar.gz"
  sha256 "bf56fde52d0f6544a2ca3db6d4552867e5cf9daf1c5a31f8b3ad6e3258986b0f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur: "0c33d537b44ce397cb3b4b7ee5c686280605eee88c0b5b2814f2fd2699d1d88d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e2cddf6c2b08741774dff4f01aae9ff52eb06726bdfd89f02026e83865e65d0e"
    sha256 cellar: :any_skip_relocation, catalina: "7e9aa3af0f6c2fcb50c2b53689e1a32faa1a21806539ff53d505ebe7283b8d51"
    sha256 cellar: :any_skip_relocation, mojave: "b9573536a98e6ed6180a58386de775cf50e3851a910158f78e1102f26eb6fff1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/procs")
    count = output.lines.count
    assert count > 2
    assert output.start_with?(" PID:")
  end
end
