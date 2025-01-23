class KubeBench < Formula
  desc "Checks Kubernetes deployment against security best practices (CIS Benchmark)"
  homepage "https://github.com/aquasecurity/kube-bench"
  url "https://github.com/aquasecurity/kube-bench/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "dc5952800fdf8a4464e1939e7b6cdaabde97c8064ec82a3d7bb365753e0b2c32"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/kube-bench.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8fdd4bdf28e3f9db48299b88c7a561e657041a4f5b4a4c65a3e78db064ec90b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8fdd4bdf28e3f9db48299b88c7a561e657041a4f5b4a4c65a3e78db064ec90b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8fdd4bdf28e3f9db48299b88c7a561e657041a4f5b4a4c65a3e78db064ec90b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb9d0b8ed2efd3d6c33342cb9a394b0c91fe0efac73646da8a30510d3543911d"
    sha256 cellar: :any_skip_relocation, ventura:       "fb9d0b8ed2efd3d6c33342cb9a394b0c91fe0efac73646da8a30510d3543911d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6b3e20b01972a9eb036ba32b733ae5f31fd5a844386932ca6df8bdc527010b2"
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
