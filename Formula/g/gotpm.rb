class Gotpm < Formula
  desc "CLI for using TPM 2.0"
  homepage "https://github.com/google/go-tpm-tools"
  url "https://github.com/google/go-tpm-tools/archive/refs/tags/v0.4.7.tar.gz"
  sha256 "c2e95054ed9aee5a304dc31e9b25f2a945d52764352eec399b007e8214e10a0c"
  license "Apache-2.0"
  head "https://github.com/google/go-tpm-tools.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e1fbf201152c1d92e0fee354a2736c1c9ecd1cf1f657d3b9df4f0c2bbf547424"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1fbf201152c1d92e0fee354a2736c1c9ecd1cf1f657d3b9df4f0c2bbf547424"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1fbf201152c1d92e0fee354a2736c1c9ecd1cf1f657d3b9df4f0c2bbf547424"
    sha256 cellar: :any_skip_relocation, sonoma:        "37e6a3f7449e763691e10f7355279e2d3043923cce437f25ff5db98ea80af47d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d097bb0ed3355e982eeee89dadcd9d3da64eb5ab14e0c44d6bc77749956f5eef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0be077482b2c4d14b4a8f86a6b5a4235215b4a9d5b4f22659e94dc72e3a282e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gotpm"
    generate_completions_from_executable(bin/"gotpm", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/gotpm attest 2>&1", 1)
    assert_match "Error: connecting to TPM: stat /dev/tpm0: no such file or directory", output
  end
end
