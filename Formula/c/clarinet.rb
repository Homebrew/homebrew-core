class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://stackslabs.com/"
  url "https://github.com/stx-labs/clarinet/archive/refs/tags/v3.13.1.tar.gz"
  sha256 "e8b05f5cb9cdeb2dcff46b57793010a9a9cef4f526bdef79cb93329d2a061173"
  license "GPL-3.0-only"
  head "https://github.com/stx-labs/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "449e580af4b989958ca71389a0c1564d7fed08148ac56080ae4932d02778bce9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1591569575e727d525bae792619c3740ee13d0143a530570a4899607e1a2f204"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "abf3660396ab9e967bd8afcf4d4811e060632a8a7ca6e02690f8dadee5ee99d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "425b60dad478c71abaf2d0a4fe21ebad1262704fcdd6a5228a6e71557dc25b0c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "266574d772b0b59ea40c121886f5a5d0d66983dcb7af525b75026efb950a7e0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7700dab0fffb45ab9ec216745371f0dc26b5ff1689a12b3f843b980ccffdbdac"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "components/clarinet-cli")
  end

  test do
    pipe_output("#{bin}/clarinet new test-project", "n\n")
    assert_match "name = \"test-project\"", (testpath/"test-project/Clarinet.toml").read
    system bin/"clarinet", "check", "--manifest-path", "test-project/Clarinet.toml"
  end
end
