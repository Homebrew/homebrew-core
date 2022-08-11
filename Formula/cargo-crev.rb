class CargoCrev < Formula
  desc "Code review system for the cargo package manager"
  homepage "https://web.crev.dev/rust-reviews/"
  url "https://github.com/crev-dev/cargo-crev/archive/refs/tags/v0.23.2.tar.gz"
  sha256 "b37ca10e252bcd352634aed7ea366dfa84900446dbd74888f3178c0c10068d10"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ede0b15fa734e7730c69fbc3a4550ab6b6b960a33c345f98e8fd978b16bc1e88"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a62e0e3f0295fd02f155bb97e2eaad9aee0f42ad9fb8aeb5c99ca1028a6726d0"
    sha256 cellar: :any_skip_relocation, monterey:       "279414932a0857cabc8b08a9029558c593476cb6855fdc7f57bb230f1196d33c"
    sha256 cellar: :any_skip_relocation, big_sur:        "f52e032eceb316884d1212da94c6e4b08b19e4bcc78f2eca8772752fc0639353"
    sha256 cellar: :any_skip_relocation, catalina:       "ea894cb6be134d8e1dea3d819848793dcaadba8dfef1c176bf2f68bd4a840b06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2693a58c57b99ee164d94d2914c5fda71dd031aa5044d88c58b05ca02c89c973"
  end

  depends_on "rust" => [:build, :test]

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args(path: "./cargo-crev")
  end

  test do
    system "cargo", "crev", "config", "dir"
  end
end
