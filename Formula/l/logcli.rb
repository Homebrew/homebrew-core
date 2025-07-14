class Logcli < Formula
  desc "Run LogQL queries against a Loki server"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.5.2.tar.gz"
  sha256 "d669f543b7f5e9fdbd3aef94cc8f02f618617c88125398496d99b9c162ef7f7b"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7e299801387c89a7f2ad7849e845afd5db1d1a631d8d2935b805eebce5811f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b3a1b89d919a2c24c1a39b834fdffa45b8a750beedf709771cbedb2ee50b7f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2081ea0a06cc8a33a2b6db06d90431f4b133da60c7021545ed7f3c4f36c5dab3"
    sha256 cellar: :any_skip_relocation, sonoma:        "21eef20e7ac7b084bb6491b1c89d6d807b70990b1cec5a5c1cf23649a6c76385"
    sha256 cellar: :any_skip_relocation, ventura:       "53228274fdd9266e8dd1b9de18cc67336205366665b91cf27a61f9ba4a3d8380"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df819082203fc94b7a5077f4d0a49bd56a249ea4efa236250eeedca7e22ac0f9"
  end

  depends_on "go" => :build
  depends_on "loki" => :test

  # Fix to link: duplicated definition of symbol dlopen
  # PR ref: https://github.com/grafana/loki/pull/17807
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/f49c120b0918dd76de81af961a1041a29d080ff0/loki/loki-3.5.1-purego.patch"
    sha256 "fbbbaea8e2069ef0a8fc721f592c48bb50f1224d7eff94afe87dfb184692a9b4"
  end

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

    fork { exec Formula["loki"].bin/"loki", "-config.file=loki-local-config.yaml" }
    sleep 3

    assert_empty shell_output("#{bin}/logcli --addr=http://localhost:#{port} labels")
  end
end
