class Mcap < Formula
  desc "Serialization-agnostic container file format for pub/sub messages"
  homepage "https://mcap.dev"
  url "https://github.com/foxglove/mcap/archive/releases/mcap-cli/v0.0.29.tar.gz"
  sha256 "89f0bec97d59e293ee8547f88e38c10e36437216cbbc4203e58fa3e544767ca5"
  license "MIT"
  head "https://github.com/foxglove/mcap.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^releases/mcap-cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d384ea822505d4b2022e7ce1ea11806014834eae8114037e1610ed67b241f19d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6cd73be10f38e2aa3e84886af253b85be0ff30bdac69af66ffc9b22b642bfb2d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "068574ce88cf0835309acbb08b7de45dc000d7e70e955044f605a7c9e89db650"
    sha256 cellar: :any_skip_relocation, ventura:        "a720ddf71ba6a0f0c4f01dd021c07c3530232449b9ed7a02093450c006d7aa4c"
    sha256 cellar: :any_skip_relocation, monterey:       "23afe4e3f80256790c9cb0520a4bf20ad383e72299e664cf38d35311e5a66209"
    sha256 cellar: :any_skip_relocation, big_sur:        "b7533698813fc768657c4aaca0640053dfccba7056359876b7eb537e96b256cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a5186e32302f8754df958a415310289618fa3b95f6a6a99a1fa0de85dcdf1c7"
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
