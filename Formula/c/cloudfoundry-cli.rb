class CloudfoundryCli < Formula
  desc "Official command-line client for Cloud Foundry"
  homepage "https://docs.cloudfoundry.org/cf-cli"
  url "https://github.com/cloudfoundry/cli/archive/refs/tags/v8.10.2.tar.gz"
  sha256 "d156b908e959ffb3ce1d91a55e88f8b7c554e8c9b33190183757fc959785ee5a"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?((?!9\.9\.9)\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99eb662ef37e6f7aca6659d249a4230d612708335f70b5b65ac0cc12c9548f4f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99eb662ef37e6f7aca6659d249a4230d612708335f70b5b65ac0cc12c9548f4f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "99eb662ef37e6f7aca6659d249a4230d612708335f70b5b65ac0cc12c9548f4f"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d596c8ef0c5d99670b23f670cb8eead3fb27f58053f795eda103d7d742e39fc"
    sha256 cellar: :any_skip_relocation, ventura:       "9d596c8ef0c5d99670b23f670cb8eead3fb27f58053f795eda103d7d742e39fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f9c95e49d0f32891a6a597dde68a019588d3abf3dde76c75262bcf964a36748"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X code.cloudfoundry.org/cli/version.binaryVersion=#{version}
      -X code.cloudfoundry.org/cli/version.binarySHA=#{tap.user}
      -X code.cloudfoundry.org/cli/version.binaryBuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"cf")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cf --version")

    expected = OS.linux? ? "Request error" : "lookup brew: no such host"
    assert_match expected, shell_output("#{bin}/cf login -a brew 2>&1", 1)
  end
end
