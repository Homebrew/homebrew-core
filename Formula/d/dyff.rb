class Dyff < Formula
  desc "Diff tool for YAML files, and sometimes JSON"
  homepage "https://github.com/homeport/dyff"
  url "https://github.com/homeport/dyff/archive/refs/tags/v1.10.3.tar.gz"
  sha256 "07ab1b365f876f92121ef5aa010de26f13a5bf495d29ee886d8781051dce3ea9"
  license "MIT"
  head "https://github.com/homeport/dyff.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ca0fa87102d972896699f21fe03d568ac44c612c543c9f2d795745bed318f62"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ca0fa87102d972896699f21fe03d568ac44c612c543c9f2d795745bed318f62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ca0fa87102d972896699f21fe03d568ac44c612c543c9f2d795745bed318f62"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ab5d87309c094322025eabfec3e290c16c82a0f37c5750ddc451723f87b711b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a723f317c0d376ac0caa4035916abe657059b272dc44d0c02fdd2096463e693"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4f47f8ee55831732ab2ac7a3dc6fa6e0d2d21de056ace6253d337289ae9237a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/homeport/dyff/internal/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/dyff"

    generate_completions_from_executable(bin/"dyff", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dyff version")

    (testpath/"file1.yaml").write <<~YAML
      name: Alice
      age: 30
    YAML

    (testpath/"file2.yaml").write <<~YAML
      name: Alice
      age: 31
    YAML

    output = shell_output("#{bin}/dyff between file1.yaml file2.yaml")
    assert_match <<~EOS, output
      age
        ± value change
          - 30
          + 31
    EOS
  end
end
