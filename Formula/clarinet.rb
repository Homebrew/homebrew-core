class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://github.com/hirosystems/clarinet"
  # pull from git tag to get submodules
  url "https://github.com/hirosystems/clarinet.git",
      tag:      "v1.1.0",
      revision: "f91140d10bd0f7a1bebfed8ce8fbb30093bce336"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40f6cc36b93b94fc54041b29b9bba59c582a82756dd63943d363a7548877fdab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ac30bff202d0c7eb35cde31dd205da3f7a54bd6c901ca3703b05fa2c4070be4c"
    sha256 cellar: :any_skip_relocation, monterey:       "b45337a0ebb3d69353d5e389494f5362f284e8872be06b3e42daa6d64ca7e547"
    sha256 cellar: :any_skip_relocation, big_sur:        "012c36771f87eaddfdcdaa302161710462cb0d9e4c5bedca7a3778d5358b9be4"
    sha256 cellar: :any_skip_relocation, catalina:       "e27ada7401927857f89fd66afd26db2060963ad4aa4e8ca66b3e76dac8576678"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12da446cec58c8042bd612ea2a3a3fadc01068cc1731b993e4f126cb021e9c58"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "clarinet-install", "--root", prefix.to_s
  end

  test do
    pipe_output("#{bin}/clarinet new test-project", "n\n")
    assert_match "name = \"test-project\"", (testpath/"test-project/Clarinet.toml").read
    system bin/"clarinet", "check", "--manifest-path", "test-project/Clarinet.toml"
  end
end
