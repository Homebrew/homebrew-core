class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://www.hiro.so/clarinet"
  url "https://github.com/hirosystems/clarinet/archive/refs/tags/v2.15.2.tar.gz"
  sha256 "25cd4a232b8ea3a578f5da4b8c7bda70d268b82f0888fcbbe492600aff5fc0be"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d35105b746e89b98d81c6f59c66a3c41de298df49a143943cf827bc3f7413b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2fbf59fe4dbcbd47799a852deac8ca8eb6e059111723b51c21f754f48a110b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "80411c4cc490d2140d517282d84fa82dfb9213f058e0c117603f4feea3956344"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f8f8d2bddd07f236673ba1005d8e208a81a81c2a38c503267d2def95fc93c1a"
    sha256 cellar: :any_skip_relocation, ventura:       "0af7c7bdaa38064c46dcbb161818abd77642a834a8e1dc5ad351362f1037fd04"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d826876698e75fc2ad7b3771ef31dab8f8119ede23f8eb24d5b14c43865798d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ebd518cb62430598655ec32adb836505c98a6f97f4122550eb039b3f2c74fa3"
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
