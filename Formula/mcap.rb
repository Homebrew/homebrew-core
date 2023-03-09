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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "83e09f1e1b214ac1368e14475486d9cb0529853d5f3c8e8145ead0109b8c4397"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "abe493465c9594331ce4ef3e432bf3d4dfb00ef8d8b80e16e3f652c25ff837fa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "133824ff54d78e94194a5f62c4aee2869afa7a336d6b8daddf64e075f861b6e3"
    sha256 cellar: :any_skip_relocation, ventura:        "0d77f68eb21d30c908e37b830ffc0bf3378b7a93021a16b4bab650907b939039"
    sha256 cellar: :any_skip_relocation, monterey:       "8b3a6751b20e1c852c95ae7c7f276571f387fef879708073593ecf56cdc4873e"
    sha256 cellar: :any_skip_relocation, big_sur:        "ee29afe5ca523d6b9d2e8ded6b8bbf06e5f289adb3e3a3c99c4ba9351761af61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db3ebe0c3d94150d8f25ee9a9275e949ce77ab6287f27434bd9953c5c4b6ab75"
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
