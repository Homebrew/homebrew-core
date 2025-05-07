class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://www.hiro.so/clarinet"
  url "https://github.com/hirosystems/clarinet/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "79675dd0a44bea0f136029b9c7ec4de1eefd8cefd2e9535ecd9344b3ea401ab2"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ea6de4eea6b99d096ea90edc44da4c13946024e67915f55881f99b5dd40e6e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3fe529e1381aed381b0fb0f61164c67f6b20254495711fa737f608e45d8a0934"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "666917ca33f8a0729f8de9ab8dce11c92cb864bbde5e0b57a62da23f30930000"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a3bf48813bf4aa16bad6ac1a711307b7242946d632cd62d634b45f38fd6d836"
    sha256 cellar: :any_skip_relocation, ventura:       "50f33a495eca2e2594b14c1ee4f03ce535ac7091149f017707e86ec2a2042a51"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b496ae610979e3366e4fbc00e326d3d4b64c4475fcaaecaadf08def1a6d50a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb791d3770f42b844dccd647b058d3c8ff11a95d84901a08c7850459bce22428"
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
