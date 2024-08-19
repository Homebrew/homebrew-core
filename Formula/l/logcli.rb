class Logcli < Formula
  desc "Run LogQL queries against a Loki server"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.1.1.tar.gz"
  sha256 "d53a46e3ee51a258f49f865cc5795fe05ade1593237709417de0e1395b5a21cf"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7d8e2562c748d475138e699c6ede2536fba6349d6da6ebdf00e110e5ac01c9c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7135b0f293021cb718ed9779745926e2201b3ac7bbcc9f79d2f6a04f4e899f55"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "342b53e5b75453b9f4344d7d73bfc76aec14a64bb2772738c1318abc273db222"
    sha256 cellar: :any_skip_relocation, sonoma:         "322e963ba8e2d59debb51f3a4767bd2e0c5163d2cf49aa05b0b6b530b0d4d396"
    sha256 cellar: :any_skip_relocation, ventura:        "91a0966aa2f94a5cc469ff881707d2778fc8ca700546c52c6c5a3f3aa3d75b74"
    sha256 cellar: :any_skip_relocation, monterey:       "b5f05f0e019432d2f85d7cdb102055fb38d5ba9b6a008c67fc82509ac1ab3d4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2848d43d3f280d4d337cf2a0f431d2a8969ab0cd0dad1f94819ef2ed36d7cbcf"
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
