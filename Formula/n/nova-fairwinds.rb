class NovaFairwinds < Formula
  desc "Find outdated or deprecated Helm charts running in your cluster"
  homepage "https://github.com/FairwindsOps/nova"
  url "https://github.com/FairwindsOps/nova/archive/refs/tags/v3.11.4.tar.gz"
  sha256 "e4364254b385a84701ff649bb47114b5e7b5a59d3d1e61a12ea9663715164fd8"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/nova.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c174a2a5eb9356b05a26436bccfe364e69cb5d72e6595f347431eee8cdb186ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c174a2a5eb9356b05a26436bccfe364e69cb5d72e6595f347431eee8cdb186ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c174a2a5eb9356b05a26436bccfe364e69cb5d72e6595f347431eee8cdb186ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a673713f994a9add1153d1a493b723a840267558442009aa947a93c28cc4de6"
    sha256 cellar: :any_skip_relocation, ventura:       "8a673713f994a9add1153d1a493b723a840267558442009aa947a93c28cc4de6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "331adffe27708f500644c742da1a3b7f6ff119aeaac9e3fe8b298440d098bbd1"
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
