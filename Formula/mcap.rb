class Mcap < Formula
  desc "Serialization-agnostic container file format for pub/sub messages"
  homepage "https://mcap.dev"
  url "https://github.com/foxglove/mcap/archive/releases/mcap-cli/v0.0.24.tar.gz"
  sha256 "54dee25b2484e105ca6b0469a3022887de13183b1fb0b68bba3ff23ed42c56b0"
  license "MIT"
  head "https://github.com/foxglove/mcap.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^releases/mcap-cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e8d730627d09b31c2b4a4069a2ea057df90184da1f8a4ef90b5b98f793e0ef0a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f33d7a3b8e11d152edefedb3afc1de1ac95b4fc8b458ad2ddcdcb585b37f58db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f55b70cdea67780d9c028e7fe75e4ad45453537970761279141d480960b362c0"
    sha256 cellar: :any_skip_relocation, monterey:       "0c09ee198618e14a7964ba86366ccdffc3a0004215907ea86cb8dbdb5880f822"
    sha256 cellar: :any_skip_relocation, big_sur:        "0d8687b23c64a9d9594c158e0b8860be1721f0784c5d017b82e9b416d6b56d4e"
    sha256 cellar: :any_skip_relocation, catalina:       "2348216afda7eaa47075cd32f5de0d11c4334682219f8dc08af0d49a75196c02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c333adb10a0ef2ae5548a5c5f6717c79078ceb2460c8ca83b17a97315da8974f"
  end

  depends_on "go" => :build

  resource "homebrew-testdata-OneMessage" do
    url "https://github.com/foxglove/mcap/raw/releases/mcap-cli/v0.0.20/tests/conformance/data/OneMessage/OneMessage-ch-chx-mx-pad-rch-rsh-st-sum.mcap"
    sha256 "16e841dbae8aae5cc6824a63379c838dca2e81598ae08461bdcc4e7334e11da4"
  end

  resource "homebrew-testdata-OneAttachment" do
    url "https://github.com/foxglove/mcap/raw/releases/mcap-cli/v0.0.20/tests/conformance/data/OneAttachment/OneAttachment-ax-pad-st-sum.mcap"
    sha256 "f9dde0a5c9f7847e145be73ea874f9cdf048119b4f716f5847513ee2f4d70643"
  end

  resource "homebrew-testdata-OneMetadata" do
    url "https://github.com/foxglove/mcap/raw/releases/mcap-cli/v0.0.20/tests/conformance/data/OneMetadata/OneMetadata-mdx-pad-st-sum.mcap"
    sha256 "cb779e0296d288ad2290d3c1911a77266a87c0bdfee957049563169f15d6ba8e"
  end

  def install
    cd "go/cli/mcap" do
      system "make", "build", "VERSION=v#{version}"
      bin.install "bin/mcap"
    end
    generate_completions_from_executable(bin/"mcap", "completion", shells: [:bash, :zsh, :fish])
  end

  test do
    assert_equal "v#{version}", shell_output("#{bin}/mcap version").strip

    resource("homebrew-testdata-OneMessage").stage do
      assert_equal "2 example [Example] [1 2 3]",
      shell_output("#{bin}/mcap cat OneMessage-ch-chx-mx-pad-rch-rsh-st-sum.mcap").strip
    end
    resource("homebrew-testdata-OneAttachment").stage do
      assert_equal "\x01\x02\x03",
      shell_output("#{bin}/mcap get attachment OneAttachment-ax-pad-st-sum.mcap --name myFile")
    end
    resource("homebrew-testdata-OneMetadata").stage do
      assert_equal({ "foo" => "bar" },
      JSON.parse(shell_output("#{bin}/mcap get metadata OneMetadata-mdx-pad-st-sum.mcap --name myMetadata")))
    end
  end
end
