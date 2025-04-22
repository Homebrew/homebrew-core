class KubeBench < Formula
  desc "Checks Kubernetes deployment against security best practices (CIS Benchmark)"
  homepage "https://github.com/aquasecurity/kube-bench"
  url "https://github.com/aquasecurity/kube-bench/archive/refs/tags/v0.10.4.tar.gz"
  sha256 "14170ec61b7acf97b716f4b5f6457c9857f8b82c1e321a700ac93c09742bec68"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/kube-bench.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c76a1267f72d7efac0a8fd687790365efc765c19533e275860acaafd88459dc9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c76a1267f72d7efac0a8fd687790365efc765c19533e275860acaafd88459dc9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c76a1267f72d7efac0a8fd687790365efc765c19533e275860acaafd88459dc9"
    sha256 cellar: :any_skip_relocation, sonoma:        "634ab6bb8ce0a480c5c3a65a9d2d2512a0289c52a1c80a790a835fcd6a2e330d"
    sha256 cellar: :any_skip_relocation, ventura:       "634ab6bb8ce0a480c5c3a65a9d2d2512a0289c52a1c80a790a835fcd6a2e330d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a621394c590c02033436b6ea1d07e37bc2bed41fdbcd9c07e66896eb4f82a0a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/aquasecurity/kube-bench/cmd.KubeBenchVersion=#{version}")

    generate_completions_from_executable(bin/"kube-bench", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kube-bench version")

    output = shell_output("#{bin}/kube-bench run 2>&1", 1)
    assert_match "error: config file is missing 'version_mapping' section", output
  end
end
