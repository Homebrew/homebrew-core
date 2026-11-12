class Kagent < Formula
  desc "Kubernetes native framework for building AI agents"
  homepage "https://kagent.dev"
  url "https://github.com/kagent-dev/kagent/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "6437c61d79dbec9a83452e34f2cf39a1c88eb6df0d6d591d61a5d5710673bfa6"
  license "Apache-2.0"
  head "https://github.com/kagent-dev/kagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "aac4a073a4a130f756483b3ee972b60393519b96d5c122d28dd7cf03fc461595"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b0b197724451d84f641b96368bbd8a5f307dfe64035ea353d959f7e3b742ba89"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5a469152ac63318bf83842df786bba16da7d50769d8d4dad2359cd10c4421708"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2c7b718222a168840150413dd5b3ba2a37bb365bd818161e0e2b027e009515bb"
    sha256 cellar: :any,                 x86_64_linux:      "698fdfddd6af5eee49fcbd094f71841b64d0c1532c131d0ba80331e487bf95a2"
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
