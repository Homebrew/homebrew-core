class NovaFairwinds < Formula
  desc "Find outdated or deprecated Helm charts running in your cluster"
  homepage "https://github.com/FairwindsOps/nova"
  url "https://github.com/FairwindsOps/nova/archive/refs/tags/v3.11.15.tar.gz"
  sha256 "4271f30e9e8f7f70135b160084d545d9b3e6c82a2221fa0f208705d100f9e6a2"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/nova.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "14dceacfd3b33b2608e10e66fbc6041c0d0b544f55bb12007210350d990521e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14dceacfd3b33b2608e10e66fbc6041c0d0b544f55bb12007210350d990521e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14dceacfd3b33b2608e10e66fbc6041c0d0b544f55bb12007210350d990521e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "9eaa7503ea557fec4ac9d8dfdacf1082a714c2665364ece35ed3f22df439de34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d82426aed0e88b8c843a247499bd804f6e171d9ea761c934a1e6a8af0bd8789e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4df793108d270d1dff36f014792f286dbc7edb05916954f31336be964fd27c5"
  end

  depends_on "go" => :build

  conflicts_with "open-simh", because: "both install `nova` binaries"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(output: bin/"nova", ldflags:)

    generate_completions_from_executable(bin/"nova", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nova version")

    system bin/"nova", "generate-config", "--config=nova.yaml"
    assert_match "chart-ignore-list: []", (testpath/"nova.yaml").read

    output = shell_output("#{bin}/nova find --helm 2>&1", 255)
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end
