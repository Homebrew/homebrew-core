class Logcli < Formula
  desc "Run LogQL queries against a Loki server"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.6.3.tar.gz"
  sha256 "1a47ed5aca892c9d0c55bfbf059b0efd8b75ae2c0140407f4d48f29bbc15d62e"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "797e81907b85fc9a964a3bbe7305078a37204e9e96caefd2573c211a5b3dc292"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e3f352b5e5601c9e5fd5947bb63dba5ff5be3da153cb25ce149da62ed656ce5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec0d3598e4e3541b1eb233265deeb76093c8440a8ea393f349d0f6bf6b387364"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a043a63267ac5cfe71477cd02c50f4f78b0a0c4047a012c07d259f40e56c6be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef69f9a6a0c7bd4c4150dd4d912e147101fa452c20a21e2141ab53268c8aec44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c398585c4c14e40606966aff84b65b80c5cba74f4b22840165f16f65f81d0cd"
  end

  depends_on "go" => :build
  depends_on "loki" => :test

  def install
    ldflags = %W[
      -s -w
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

    spawn Formula["loki"].bin/"loki", "-config.file=loki-local-config.yaml"
    sleep 3

    assert_empty shell_output("#{bin}/logcli --addr=http://localhost:#{port} labels")
  end
end
