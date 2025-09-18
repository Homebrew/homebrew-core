class Nelm < Formula
  desc "Kubernetes deployment tool that manages and deploys Helm Charts"
  homepage "https://github.com/werf/nelm"
  url "https://github.com/werf/nelm/archive/refs/tags/v1.12.2.tar.gz"
  sha256 "6c75bb60534f3e0b085a953ea97bde5949d07219970ce5ac70ec5110de00ae15"
  license "Apache-2.0"
  head "https://github.com/werf/nelm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "52dd8c2a33f050278f8eae964183bd534025c03869774eb823161c66e2c2cf7b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "303b91fcc20ee0f189e46cb2c6f56ea719d75b4f112e4c526ad85f8bde1157a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a29ff934db268e602045ffaf8b265dca00aba6c7173fe5918f69cb3f6c07dd3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "941658cf7949b3dd0e045bc0cc7bde4b5b18a1327ee5f69990eea891701a5040"
    sha256 cellar: :any_skip_relocation, sonoma:        "fbd3cb853a3bacf9e8504863a91d8941f501862b98a6ecf9f3195f32634f1b9f"
    sha256 cellar: :any_skip_relocation, ventura:       "68f21db5e3ff1cb167e78d8bc56d95cd52f78cff23841e7a8e3d8a1490ebc251"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "354e9596f0ce6467818dec6aeea13184cdd8785264d58f1dcedb1d37fc312b6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8c8809712a94adbe4e106fb0dae0efcd4290c53bd5975392215feb77b51ad79"
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
