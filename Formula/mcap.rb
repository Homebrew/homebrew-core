class Mcap < Formula
  desc "Serialization-agnostic container file format for pub/sub messages"
  homepage "https://mcap.dev"
  url "https://github.com/foxglove/mcap/archive/releases/mcap-cli/v0.0.20.tar.gz"
  sha256 "82066fd241eeb034b108213ebe540064fdb2b493e07afc86e24f244006a95acc"
  license "MIT"
  head "https://github.com/foxglove/mcap.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^releases/mcap-cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7a2a913a2210a98c2612853d819c9067f31aae16e47376913643d3960129f1f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1ccdac52d70736a41af955d39841c44a40b23178d6f4b165c9901c9dd3d089f5"
    sha256 cellar: :any_skip_relocation, monterey:       "ebac07b54f4ce2c59dab68c124d06a462007d12c342e287a4dfc896f864e666a"
    sha256 cellar: :any_skip_relocation, big_sur:        "2a07cd2da0f621eb24d16d164e37f59a9fdc5a0a206040d500b79a5f7ac5c738"
    sha256 cellar: :any_skip_relocation, catalina:       "7198194bfad45958dcac035fcb4bd2ca362abd366c49e9fe8a1b46509fac282b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ecd2eb2ae940fffeb67605ba6f3b34e07e7a3d6c5d167ac977a3dfa2aeb959f1"
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
