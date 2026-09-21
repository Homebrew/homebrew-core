class Logcli < Formula
  desc "Run LogQL queries against a Loki server"
  homepage "https://grafana.com/oss/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.7.8.tar.gz"
  sha256 "313a9c2de71ca7ffca1189f6ac2916073df36f498f2d6f77130d07bcd6fc5724"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "72c99f82bafcfe71ebdc95f75c2bed6ad32e894d0134e33dd7f5681f4986c8f9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2771a20e92d6ea7f59d4bde4c9fad1a2ed50ece8b75f8b36c81e964388065fe3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6de3cc2803bfef2a910bd9df805f7b09c11601531acbf52732e0a55cb02bcccd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1a799da2a42fbe65ae43abbe56bb3d90fc2b1d50c86d1e5db6b5a86776cddf96"
    sha256 cellar: :any,                 x86_64_linux:      "e81918580815560b083b39551b430d195d01057e52b7472c5cee7a004e12671f"
  end

  depends_on "go" => :build
  depends_on "loki" => :test

  # `test do` block runs a local loki server
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/grafana/loki/pkg/util/build.Branch=main
      -X github.com/grafana/loki/pkg/util/build.Version=#{version}
      -X github.com/grafana/loki/pkg/util/build.BuildUser=#{tap.user}
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
      url "https://raw.githubusercontent.com/grafana/loki/5c8542036609f157fee45da7efafbba72308e829/cmd/loki/loki-local-config.yaml"
      sha256 "14557cd65634314d4eec22cf1bac212f3281854156f669b61b17f2784c895ab1"
    end

    port = free_port

    testpath.install resource("homebrew-testdata")
    inreplace "loki-local-config.yaml" do |s|
      s.gsub! "3100", port.to_s
      s.gsub! "/tmp", testpath
    end

    spawn formula_opt_bin("loki")/"loki", "-config.file=loki-local-config.yaml"
    sleep 3

    assert_empty shell_output("#{bin}/logcli --addr=http://localhost:#{port} labels")
  end
end
