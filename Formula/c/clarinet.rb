class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://www.hiro.so/clarinet"
  url "https://github.com/hirosystems/clarinet/archive/refs/tags/v2.16.0.tar.gz"
  sha256 "a573b1a111be95c200bb0638ef6ac896a3511dea741b4ac43161f9fc9e4d5579"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b22280e0430c7035bbc81de7591433b267c87447857965a6772866e0a77dc7a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6226c8c9fb31598545cc606d4688ce6771d648a79838f16475f0866a50545af7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "49b1d4286bb806357c9757b1690b4ffe78e4f2f6bee8885b34ff48496cb5855f"
    sha256 cellar: :any_skip_relocation, sonoma:        "2915938d8f1c81b7ecf0d716e35681ace0c07a48fe3045c52a4c790e201e50b4"
    sha256 cellar: :any_skip_relocation, ventura:       "bf32217fc5caab7bcc51af25749a40e0f556edb10a9d4c9dfc386747845a865e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f1b8ebbacb745ad636719d9c18ef31bcfe2edc2145ed4c2df9bef62687f637c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69579e0f800bd56ccffe36b6b72960220bd976fed8d8980fab1b751dcd6e9f13"
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
