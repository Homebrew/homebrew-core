class Mcap < Formula
  desc "Serialization-agnostic container file format for pub/sub messages"
  homepage "https://mcap.dev"
  url "https://github.com/foxglove/mcap/archive/releases/mcap-cli/v0.0.32.tar.gz"
  sha256 "24c2485eebf6e6f8a53c0881fa84c319635637dd0fb5293b11bc905d367f46fb"
  license "MIT"
  head "https://github.com/foxglove/mcap.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^releases/mcap-cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6d0f4d8c806f48636a6a3c458bf234f6700e473a85ae94dadb496673d4a4cf6a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc96bf4ed69e0e6c97b328d31cc398d8fb29c594004e34716b3edc338d10e335"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a4898534022491fcf1bee7642ec4803bc810e9d46a634b212c12ca0d173c2e5c"
    sha256 cellar: :any_skip_relocation, ventura:        "b351b42b7290b38982d0758db92aefa3c5735725d9ec42f075661cc344669129"
    sha256 cellar: :any_skip_relocation, monterey:       "eb6c749284450fc389cd662d13f6c436a7b9459c71bf3ec8655244cf14b70106"
    sha256 cellar: :any_skip_relocation, big_sur:        "682ac511d2e1c5ffaec3dc83a884a794b6d1bf66019220e4587481e1f3f8a28c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c9e6573435b8b1e7c29e8a866a425f15aa5df2b4563a5d98dfff91aad128280"
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
