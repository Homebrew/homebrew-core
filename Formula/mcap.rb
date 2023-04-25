class Mcap < Formula
  desc "Serialization-agnostic container file format for pub/sub messages"
  homepage "https://mcap.dev"
  url "https://github.com/foxglove/mcap/archive/releases/mcap-cli/v0.0.30.tar.gz"
  sha256 "37df20fd5f85f5f57266de7b36e5ef9b1ad7f9e648b0eb3bca2bfa4f0ff59a40"
  license "MIT"
  head "https://github.com/foxglove/mcap.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^releases/mcap-cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "70eb9c47ee7ff257ee2b6901d3cefe7f685d72fea8858bd26ca6f529d3237484"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a58116125031829fd23c8c6cd0dc525c860bc513b563cb1201bfd6ce1d1ed866"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d7bd64f620488f0d8b9638eb1e83810e930ee14666f81d4563c38c8ce205e413"
    sha256 cellar: :any_skip_relocation, ventura:        "b5a079a476a31570f09fa306bd7d3a16bdade0c34f025fc86fd736013ef6dd47"
    sha256 cellar: :any_skip_relocation, monterey:       "35fdfe6ab5f202e26434ff6cd52f070a8da051cccfc5f00ad6b02793ae1a9f87"
    sha256 cellar: :any_skip_relocation, big_sur:        "834490d97593fa110549eb2cce8c3f9727d53d11ef16a7108fee65cf8529dade"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3a455186d7f26651cb5e0eff6b0080f1ab4c2beb8bddad1e12482433e07a5a5"
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
