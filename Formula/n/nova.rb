class Nova < Formula
  desc "Find outdated or deprecated Helm charts running in your cluster"
  homepage "https://github.com/FairwindsOps/nova"
  url "https://github.com/FairwindsOps/nova/archive/refs/tags/v3.11.3.tar.gz"
  sha256 "5f70b5a904c773190e104776a42afd9b798f682b7f1bafc12c27818120a94911"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/nova.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19ce1ddbf6213ebb146cd2036bebafdea269c333f6292e36f13a22101c9bd5a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19ce1ddbf6213ebb146cd2036bebafdea269c333f6292e36f13a22101c9bd5a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "19ce1ddbf6213ebb146cd2036bebafdea269c333f6292e36f13a22101c9bd5a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4fd80c52ad1b119cb9b7e2482217be94e8967c59bc631220d94b96babaf905d"
    sha256 cellar: :any_skip_relocation, ventura:       "e4fd80c52ad1b119cb9b7e2482217be94e8967c59bc631220d94b96babaf905d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e1784c91e78d8ec6667bbea4bd7bd46c266cdd3415f8b6703b1d3cdba697e30"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version} -X main.commit=#{tap.user}")

    generate_completions_from_executable(bin/"nova", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nova version")

    system bin/"nova", "generate-config", "--config=nova.yaml"
    assert_match "chart-ignore-list: []", (testpath/"nova.yaml").read

    output = shell_output("#{bin}/nova find --helm 2>&1", 255)
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end
