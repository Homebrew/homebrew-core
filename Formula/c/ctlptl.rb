class Ctlptl < Formula
  desc "Making local Kubernetes clusters fun and easy to set up"
  homepage "https://github.com/tilt-dev/ctlptl"
  url "https://github.com/tilt-dev/ctlptl/archive/refs/tags/v0.9.6.tar.gz"
  sha256 "51af2008cf435a808cb297c9564fe94a4207da541871739bde5062a2a8ede933"
  license "Apache-2.0"
  head "https://github.com/tilt-dev/ctlptl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "453da89313082fcb816de563fcbe9631bcf80a3b3fcf377c11aca4388e47f624"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9db03c353f03a046fa876cc244cd56091f6d3927adb179d228cc33aee19796f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3c7503ccc6cd50a0df9e0ca30253a09b89d6c784f0cab5e3d953f5e5086aa686"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "1beed5579e4c6f67ac9699466173772e99d86a7f5707008aff932b302538ab77"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "12613121d8cf64647383f0323a04bc177e02e25027983f735eab27235d0e3d42"
    sha256 cellar: :any,                 x86_64_linux:      "88bb473f040239f031c7154bd9ccfc352816cebeb9f36b0ea11b5e338cf632e1"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/ctlptl"

    generate_completions_from_executable(bin/"ctlptl", shell_parameter_format: :cobra)
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/ctlptl version")
    assert_empty shell_output("#{bin}/ctlptl get")
    assert_match "not found", shell_output("#{bin}/ctlptl delete cluster nonexistent 2>&1", 1)
  end
end
