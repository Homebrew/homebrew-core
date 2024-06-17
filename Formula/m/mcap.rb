class Mcap < Formula
  desc "Serialization-agnostic container file format for pub/sub messages"
  homepage "https://mcap.dev"
  url "https://github.com/foxglove/mcap/archive/refs/tags/releases/mcap-cli/v0.0.46.tar.gz"
  sha256 "06503bff195893579113841ddf179db1f78be4d9c37edb46732d3e7435d2ddfd"
  license "MIT"
  head "https://github.com/foxglove/mcap.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^releases/mcap-cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aa4714f93fa35eb804ccf431c66a56b237d6cf42c4ad52e84a443903d9be9e5c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf09f2c31bb474b7ba6683d580087a418f7bcbe8c3bed3e835d6c7a93944b96a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bce0d438c32a1317a5b74dc4b87c35775c813ae32e74bb67677dae379fb20159"
    sha256 cellar: :any_skip_relocation, sonoma:         "9824ef70414e7217361d098337ed18eca6632c7ac2ffa1b27baf48abef44c532"
    sha256 cellar: :any_skip_relocation, ventura:        "341cef5bb22dcfb0ed61ff3ea5684f14f4d29892883c838fa96a62a938b95e80"
    sha256 cellar: :any_skip_relocation, monterey:       "0580abdd92379c841ab5a407154bd3839b123ef9694b176c517048a93a617979"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fd0b0fb42eb0c3eb04e0bcd23012804052f21d3a8f87e5e49a5522f8ee615e6"
  end

  depends_on "go" => :build

  def install
    cd "go/cli/mcap" do
      system "make", "build", "VERSION=v#{version}"
      bin.install "bin/mcap"
    end
    generate_completions_from_executable(bin/"mcap", "completion")
  end

  test do
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
