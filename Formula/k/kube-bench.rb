class KubeBench < Formula
  desc "Checks Kubernetes deployment against security best practices (CIS Benchmark)"
  homepage "https://github.com/aquasecurity/kube-bench"
  url "https://github.com/aquasecurity/kube-bench/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "8f2abbd813d1bf53b95577d7e0c5209cf20a9978ee43fae76e549ee86cfb2e0b"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/kube-bench.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2efc2c89acd7b2798df765979222ba87b1b9a2a84536a15e30f3635667f70e38"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2efc2c89acd7b2798df765979222ba87b1b9a2a84536a15e30f3635667f70e38"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2efc2c89acd7b2798df765979222ba87b1b9a2a84536a15e30f3635667f70e38"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d29d1c265ac4f437b9341b0c1a217f4ea1da46943c476a5ffb50fe5037be887"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8a10c666a88793de86be546af92d68c64646f621c9e08660f020b16ee04fca4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "deb30fce3555fdadecf50013fdd3519a7e447f350023bbdf78e0bd68cdc7cd7a"
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
