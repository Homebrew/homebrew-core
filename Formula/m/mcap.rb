class Mcap < Formula
  desc "Serialization-agnostic container file format for pub/sub messages"
  homepage "https://mcap.dev"
  url "https://github.com/foxglove/mcap/archive/refs/tags/releases/mcap-cli/v0.0.43.tar.gz"
  sha256 "dd2f07f1c03af2501afef7a8e85183e98e316041ba33f451898eb04d4f832f53"
  license "MIT"
  head "https://github.com/foxglove/mcap.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^releases/mcap-cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "658f02a6448d4a198b02ac575d27988287d8a7c0a477a3ea0afd4bd3b1f94c7b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc235d08b3dc61654f6ca87db0bff1b74e7c04d5d2eee7e26abaa22b147b06d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07694128ed7e9d469f83d70c56086f23d95e93d9cee9e944956e033e3fda2645"
    sha256 cellar: :any_skip_relocation, sonoma:         "55bb622c5f5469a843fbc4092ee855594a71cfbb1e91325a7bc5bff3e652b627"
    sha256 cellar: :any_skip_relocation, ventura:        "609da88424de31291239ac5c40a455c7bfc2d3981718daf51dbcaf014d1b067a"
    sha256 cellar: :any_skip_relocation, monterey:       "199a6bee05563090df3701dacc3d9a3c95cbceab18ea4971700095d58397da45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8192f4ffc7bf6fad6f5800fe67420263f9c2a74f59a2528cecc2cb8a8c118dc"
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
