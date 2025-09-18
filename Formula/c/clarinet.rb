class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://www.hiro.so/clarinet"
  url "https://github.com/hirosystems/clarinet/archive/refs/tags/v3.6.1.tar.gz"
  sha256 "a99b0261928d19e5edc3fdef86018a58824f6c0620e988e8cda9af4949750587"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f376488eff2caf35ef36e146b1b10f37ed914bbdf8bc720e6b6a5d099cce1962"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd863f1bc97b93bffff1af34f0e182bec671d6a351d5b78c0f42703ec8f01c5a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "507a8ac3ecf6b555ce0b3dd8b3cbc3666b7d46aacd2a539a046740ff4c890114"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "be90d3814bdb9bc165e7782dd011e35d3dc73da9a05308f1c9860efec7319e46"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9b9524d5c5594c9fd6aeb94d07c04278799da9462b5f63c59ce8f4c783bfaf7"
    sha256 cellar: :any_skip_relocation, ventura:       "2a6bc2402b745703e0814fbd53ff73964f66a36a305daf329c4e8fe6367773dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "163efd6b4c9bf0990be1a095dee037d2c4032e07d07cb01970df98e1bae4f79d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3789f8176a8d653416338218ae6843dd8e3556be59671e4cd2136914e9835cc4"
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
