class Epinio < Formula
  desc "CLI for Epinio, the Application Development Engine for Kubernetes"
  homepage "https://epinio.io/"
  url "https://github.com/epinio/epinio/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "61721f2c6599358353eae6325c1ea4ba769cdaee29f1e5602bb0fc279dc65cb0"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a03f3cddb27ff713c3275ff8f51f9a28eb3ee6cef10d05a3d87d989141f35de6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f84c430a10e92100b07cf02cfcdff8f7c5acf608e49ca97da9730f115c89b132"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d297d2ba42a746f0efd15be2525761bcedfada7954a759d9db9601e074838b9a"
    sha256 cellar: :any_skip_relocation, ventura:        "a688b853670210fbff58b29667c86b21141a9308663d17a33d29772af468a35d"
    sha256 cellar: :any_skip_relocation, monterey:       "e1b13fe45a24f64311336674aa944780ad8273c425a813b71e73755436ee5b5d"
    sha256 cellar: :any_skip_relocation, big_sur:        "8c15844f6b95aea295f35a671af57cdb610fe0719db1549f0d4829fadd3c883b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f2145cf395903ba817b23fc42fc3c83c00b03c8b2236ca7d43c3671f26ab16a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/epinio/epinio/internal/version.Version=v#{version}")

    generate_completions_from_executable(bin/"epinio", "completion")
  end

  test do
    output = shell_output("#{bin}/epinio version 2>&1")
    assert_match "Epinio Version: v#{version}", output

    output = shell_output("#{bin}/epinio settings update-ca 2>&1")
    assert_match "failed to get kube config", output
    assert_match "no configuration has been provided", output
  end
end
