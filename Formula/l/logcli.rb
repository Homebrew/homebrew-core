class Logcli < Formula
  desc "Run LogQL queries against a Loki server"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "480994460326bf3a3723713e7385d8f02b16f00f7fc1db8ee374f7ffe496e6ba"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78c99c9b4d3bcf41e0c69eb66e3e462e4b49d8f1bebab2222979ea268ebccfc4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09d75087b992d74e7c6b6598807bcfddeeae658019cd558cc0624f915151939f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "737619b3bc4c1510f006abe9987ec47cf30accfae43fde7d7d2ab2f3f9b4bb04"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6a655db4f073c45de1d5a9356fb9490918016a555c81bdf4621e662ab68c70a"
    sha256 cellar: :any_skip_relocation, ventura:       "87a1deca20377ea9080133826f50b129d0e3318e35033f6038b05bd05e3dde97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0d93a80b322ea6fd73e999752de9ddc7deae11bba332fa483ce14fbbe286b2a"
  end

  depends_on "go" => :build
  depends_on "loki" => :test

  def install
    ldflags = %W[
      -s -w
      -X github.com/grafana/loki/pkg/util/build.Branch=main
      -X github.com/grafana/loki/pkg/util/build.Version=#{version}
      -X github.com/grafana/loki/pkg/util/build.BuildUser=homebrew
      -X github.com/grafana/loki/pkg/util/build.BuildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/logcli"

    generate_completions_from_executable(
      bin/"logcli",
      shell_parameter_format: "--completion-script-", shells: [:bash, :zsh],
    )
  end

  test do
    resource "homebrew-testdata" do
      url "https://raw.githubusercontent.com/grafana/loki/b286075428a6cc7f58040bbdec6c81a97b626852/cmd/loki/loki-local-config.yaml"
      sha256 "2526c97ba82915499d134d8fb6f3dad2828065531818ff94798b36cd9a59e8e2"
    end

    port = free_port

    testpath.install resource("homebrew-testdata")
    inreplace "loki-local-config.yaml" do |s|
      s.gsub! "3100", port.to_s
      s.gsub! "/tmp", testpath
    end

    fork { exec Formula["loki"].bin/"loki", "-config.file=loki-local-config.yaml" }
    sleep 3

    assert_empty shell_output("#{bin}/logcli --addr=http://localhost:#{port} labels")
  end
end
