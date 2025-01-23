class Mcap < Formula
  desc "Serialization-agnostic container file format for pub/sub messages"
  homepage "https://mcap.dev"
  url "https://github.com/foxglove/mcap/archive/refs/tags/releases/mcap-cli/v0.0.51.tar.gz"
  sha256 "afcccadc5ac6e0da85bcd379cc0fe9d5409f1b884c0610f7614e3b93d1b9370b"
  license "MIT"
  head "https://github.com/foxglove/mcap.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^releases/mcap-cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3200fbad0757cb73425e33305fcea3298ab19d1aa70ab1bf9c6245a7f491cf12"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dfd1be1ce647bc997089495c9dd4555b578187c263b3213c40ecdb54b8a54707"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2fe0cce52562b3f7bab4ff148b578b3640da7520515c38fe889281f104cc4f34"
    sha256 cellar: :any_skip_relocation, sonoma:        "b661352a7afea54c8ed06a1e9f0a2a3b29695d9747778e0db9482cda6b71406f"
    sha256 cellar: :any_skip_relocation, ventura:       "9711c9d1941f86d41137952ca2fa3300ad00ecfae0a101b45cc33b317dfe7b1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5faabf431081f0906de51866282b64a3829ba3e749a9d1cdb078d64672823d88"
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
