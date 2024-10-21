class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://www.hiro.so/clarinet"
  url "https://github.com/hirosystems/clarinet/archive/refs/tags/v2.10.0.tar.gz"
  sha256 "c8b85de0c67a3ec83c7f5a0a813e60dd3820e4469a411aeda5e9a100bdc8b48a"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6bb05d1ed87e04c6c35421ddb593718149a278083fca73f5fd06ad7c1581c956"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d6601a4f9b639d66593cd83f91442cb13152a61d6faf9a89c764aee2422e5f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fe450c2f8b4011301d86029382aa0b08af1b490c5a1ec3c278d12a6145f968a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "4edeb57c3de71a4d0c4279152963ee093b21fc3311dab7eeb7907c75841f4d43"
    sha256 cellar: :any_skip_relocation, ventura:       "7034a4b15a821468527ffe1f3658e84814b54a70f65a83e562996e3023616f41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f647dcd1830501a5bf76ff09ffbce4da400cbdbd8b4eb8cfa30173087f0230a"
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
