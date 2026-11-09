class Kagent < Formula
  desc "Kubernetes native framework for building AI agents"
  homepage "https://kagent.dev"
  url "https://github.com/kagent-dev/kagent/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "c7fd886082871eab0d154f2f4a90cde262c978a01379c602fdb0b0939a6f65cd"
  license "Apache-2.0"
  head "https://github.com/kagent-dev/kagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4244c27e87ba0bc7b1b41deac65ea9bebab5889b1266bb372b3c463a96ae15ae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0fe737ef962148a400e36b7a0423ea5c706b4cfc930afbf57618bb6098170afb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cd383a5f9aee8e068fa0a0e784a3195aa294c7c00136949768675f5a1e17bb88"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3b43e5984881b0e9d416380a7a319d8377b5b606a271f1d595ca96040b4b7e58"
    sha256 cellar: :any,                 x86_64_linux:      "6786f942f08cf53c1d8b16dcbd2243d9ee7891a18900c71335cc7ec6f61322cf"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli" => :test

  allow_network_access! :test

  def fetch
    system "go", "mod", "download", "-C", "go"
  end

  def install
    cd "go" do
      ldflags = %W[
        -X github.com/kagent-dev/kagent/go/core/internal/version.Version=#{version}
        -X github.com/kagent-dev/kagent/go/core/internal/version.GitCommit=#{tap.user}
        -X github.com/kagent-dev/kagent/go/core/internal/version.BuildDate=#{time.strftime("%Y-%m-%d")}
      ]
      system "go", "build", *std_go_args(ldflags:), "./core/cli/cmd/kagent"
    end

    generate_completions_from_executable(bin/"kagent", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kagent version")

    (testpath/"config.yaml").write <<~YAML
      kagent_url: http://localhost:#{free_port}
      namespace: kagent
      output_format: table
      timeout: 5m0s
    YAML

    assert_match 'unknown field "kagent_url"',
      shell_output("#{bin}/kagent config validate --config config.yaml 2>&1", 1)
  end
end
