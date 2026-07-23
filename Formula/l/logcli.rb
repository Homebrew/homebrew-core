class Logcli < Formula
  desc "Run LogQL queries against a Loki server"
  homepage "https://grafana.com/oss/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.7.3.tar.gz"
  sha256 "1f74768fc476978796b49455fd962587a6b0e3b75212215ed8449f792aa5c776"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa2d6fb470c4a9f0f8db975757cc21a0692de84d0a4f53fcc0c0547117fd0f45"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b9f605735a67b39332a7ba173a5cd26a2b35b72e2e40ee7d5bdffe232af0024"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08db229a9f1143fa00025e839becad8f2eeee7f63d99a4054054da800de5dc12"
    sha256 cellar: :any_skip_relocation, sonoma:        "94b537a79cb5f9e505a7fd2d0ecc42242c200f8c1c3769eeaa56f6c4d8158443"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28db44fc62a16c4ec11268218068f7f613c562f6b499251a6778fa02fa1a2a36"
    sha256 cellar: :any,                 x86_64_linux:  "9490e9c9a9d1d000ec6f5fb2ff326c30609e044d66e2bee826d35ea3cf81c61d"
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
