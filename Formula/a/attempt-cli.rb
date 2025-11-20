class AttemptCli < Formula
  desc "CLI for retrying fallible commands"
  homepage "https://github.com/MaxBondABE/attempt"
  url "https://github.com/MaxBondABE/attempt/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "59a5a250de15ec14802eec19b6c63de975ccb72d2f205f1402bef94cf30b2f10"
  license "Unlicense"
  head "https://github.com/MaxBondABE/attempt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f3d246f8da65165d17c588dc3bf1231532e0c8c666fc2f5bac8493c9a6911f6b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6affd2438d988a8bf47fa4991d1df98c07b0e7e92940de0b69f8d5816269432"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b946258b9c500cb93ed7609477acf244e29c94dc90e6454e250407e912588f49"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2830afa1aae71e0dd566895e9ee24a87831d1cb175e60a157493392c9348cc6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b19f8b44ec04231ef3b8bca972cf63df75b6ab4525c9657a350d81dc5b00751"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "405051516520cdea32998076289c1331800da5dbd81e7d16fb8d067cb6f97a56"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/attempt --version")

    output = shell_output("#{bin}/attempt fixed -a 1 -m 0s -- sh -c 'echo ok'")
    assert_match "ok", output
  end
end
