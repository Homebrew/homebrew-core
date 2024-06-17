class Logcli < Formula
  desc "Run LogQL queries against a Loki server"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "ef44e222086dc2e580394c2a1148f7c0bc5c943066a0d18498f2bf6e64ef5a1b"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ad177bb94a5117e31868f0809393fe6eb6994d360779f16ca4f118d7fa0150a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a5c63f3e73dacbf9f2eb2836f4cbd55357e1d1c9893bac06e70fddd40af77fb3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3aeaf4b0b945d915d679c4c4db2f5420991f768b1a7df29259a061db2c44c9d0"
    sha256 cellar: :any_skip_relocation, sonoma:         "8ab29d93e84402271a65dba9cbf2e0e909a90e74217475acb28970be5a146f32"
    sha256 cellar: :any_skip_relocation, ventura:        "6399f57baa23544327f660c9b22b85f6c8aaafd400258893f5ee77c99039c05d"
    sha256 cellar: :any_skip_relocation, monterey:       "68202661a841c2b073f33c8cb90f565e67a44a941d13e5583e5a92f6357e9b24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e6b2e71363846aceb7071cdae821795770338d414dcf8b1097d6df9eed9503a"
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
