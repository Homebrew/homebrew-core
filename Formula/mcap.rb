class Mcap < Formula
  desc "Serialization-agnostic container file format for pub/sub messages"
  homepage "https://mcap.dev"
  url "https://github.com/foxglove/mcap/archive/releases/mcap-cli/v0.0.26.tar.gz"
  sha256 "43ff0a450564214a014018d3d6ece7c2406be9c65e7c3deaf34279b9ebfeea8c"
  license "MIT"
  head "https://github.com/foxglove/mcap.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^releases/mcap-cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2d8537832b42b3dd57d07a85a85e7cf3cb21aac847fffaedfd65f81c7fb03209"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40deb12486065bc3e193ec4968194910c423e47a56037f00a2f8aad93187df2c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8808287d960bc5388dd1dda91353253d78b4f5e380fa9207ef8d98eadf56900c"
    sha256 cellar: :any_skip_relocation, ventura:        "42cb4484ef80773f1660d4db75319e928ee1a5c9176ca3f67e4d0ed896314e8e"
    sha256 cellar: :any_skip_relocation, monterey:       "413db5343aa7d773695c921ba41bc7150860dd110a832ace353dbd2dcf268895"
    sha256 cellar: :any_skip_relocation, big_sur:        "a583c3943197d2f7f39a44508f1885502d9061bf713c5bf582c502548e3d0b8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4980bd9da23205669a762030d489eb50215b2c61fa2be681d1d238436efe84ac"
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
