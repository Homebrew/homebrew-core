class KubeBench < Formula
  desc "Checks Kubernetes deployment against security best practices (CIS Benchmark)"
  homepage "https://github.com/aquasecurity/kube-bench"
  url "https://github.com/aquasecurity/kube-bench/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "4970d30da7532b9656b5ffef5b5963901372b4f6ca33acdad8b27b27c9aa7b47"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/kube-bench.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9af62d701e9161cd4b0288f71258f6c42cff32962cde8b1b6dbdf03f63791714"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bcc9a234c5ef370f6b1cf0e60ec85adbe6ba52639e693b77b28ef5a76134c3f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bcc9a234c5ef370f6b1cf0e60ec85adbe6ba52639e693b77b28ef5a76134c3f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bcc9a234c5ef370f6b1cf0e60ec85adbe6ba52639e693b77b28ef5a76134c3f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9deb70bbb4d3b75fa18a4ddca74af543e3c6046a29bfb69d2563e4a649793db"
    sha256 cellar: :any_skip_relocation, ventura:       "f9deb70bbb4d3b75fa18a4ddca74af543e3c6046a29bfb69d2563e4a649793db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18571d4fa7773debf6679a05a138481c0ddbe45a6723437e0e21902bdb9373bb"
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
