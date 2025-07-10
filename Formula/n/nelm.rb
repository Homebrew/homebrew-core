class Nelm < Formula
  desc "Kubernetes deployment tool that manages and deploys Helm Charts"
  homepage "https://github.com/werf/nelm"
  url "https://github.com/werf/nelm/archive/refs/tags/v1.7.2.tar.gz"
  sha256 "ec30d398459896650565bdcfde6861b854ccc38c0972302f2b7424e611ad29aa"
  license "Apache-2.0"
  head "https://github.com/werf/nelm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "114d7ae5eb0d6cabd0b1d89ea15f64cea0159bddd99a2abea9c309d004e26f1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae09210d2bef24bab72811716b07d6c7b1f1393565135f9a1f63c3352136ef54"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0a8e7ca3961df638d115e9bca64d3abe9de9f8a75ecd960578c93421ccc91164"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b12d511cc01bd1edd252f74c3eeb79f9cf767da0491c00e0925f499f5e8b52f"
    sha256 cellar: :any_skip_relocation, ventura:       "3a15fb4ddacbe32b4a967350898e2e392e53cae2b8472e268005153eac5743a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "edc3faa3fb40d0d4d87219bbcad45dc8c9d31e8bfc47de00b046f2faa43cce43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87736f4c40b8a3f392b5189617e4e065e781f7bdb562a0eca4fffeda191f846e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/werf/nelm/internal/common.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/nelm"

    generate_completions_from_executable(bin/"nelm", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nelm version")

    (testpath/"Chart.yaml").write <<~YAML
      apiVersion: v2
      name: mychart
      version: 1.0.0
      dependencies:
      - name: cert-manager
        version: 1.13.3
        repository: https://127.0.0.1
    YAML
    assert_match "Error: no cached repository", shell_output("#{bin}/nelm chart dependency download 2>&1", 1)
  end
end
