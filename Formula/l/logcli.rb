class Logcli < Formula
  desc "Run LogQL queries against a Loki server"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.5.5.tar.gz"
  sha256 "caae437c5add69761a3772c51b4bd32a5d5f03440fdf16966ab27c7036eb2701"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "78221734b027c2f8117126be5766f7df5bcd599fa052928e856c13320cba9178"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "396b0787a22e19b55c0239f7edce680c2fa1914201ebe34c4d3953dca3fc8516"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3fcaac490f9142bbc20021a2f22f22bac42925665a032ce834d391d6e5cea126"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "559f4d350d94799477b420eceda740aaf0f2cd92b17ecfa4af04ddd0b50789e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c37210720b5602b4b2f2e467d86f021f3ca8cc4dc0155ae5147e4eeaa039ec6"
    sha256 cellar: :any_skip_relocation, ventura:       "52f464090507c8d6aaa1069bc87cc2356fbe667c37ecf2b010c0481efbdb4569"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8db823dc170e7abf5b8ab0256915d3456d1b055d31ff21d04dcd891b7b9d9e81"
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
