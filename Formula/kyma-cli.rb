class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli/archive/2.15.0.tar.gz"
  sha256 "73f79057971e74be369bfc6bb7ede3663e6b40ada4463c7d8878e64ceadfc85a"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "37c30a03619d160110d555afaa19b68b758b1ed51e3eaf0e948fb0b2f188770a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d682a6bc98fbca990ad0f9b6885fbbb4b637ef89c60e754a6b99c226fa1868d6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cf00a85ce050b66d8fd5d8339de9683f36184a06c2dfeb441d302e7f8aae0d8b"
    sha256 cellar: :any_skip_relocation, ventura:        "a98e615ff4c92730796140754232f53f8000d67595935ebf240b41c40b3b10c1"
    sha256 cellar: :any_skip_relocation, monterey:       "ce2a2c839ce6251d3a2a71d64e393511b680f50c82c3be397b74f048470fcd5e"
    sha256 cellar: :any_skip_relocation, big_sur:        "ecc77c2c041f090675d82dd5625e362616065bf81b556db466b2bb0d13d43e77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6ade087b6a4d65e2c0154c3ec3b2600c14929a0878367dbc04069982eb16b8e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kyma-project/cli/cmd/kyma/version.Version=#{version}
    ]

    system "go", "build", *std_go_args(output: bin/"kyma", ldflags: ldflags), "./cmd"

    generate_completions_from_executable(bin/"kyma", "completion", base_name: "kyma")
  end

  test do
    touch testpath/"kubeconfig"
    assert_match "invalid configuration",
      shell_output("#{bin}/kyma deploy --kubeconfig ./kubeconfig 2>&1", 1)
  end
end
