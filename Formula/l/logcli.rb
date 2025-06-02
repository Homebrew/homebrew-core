class Logcli < Formula
  desc "Run LogQL queries against a Loki server"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.5.1.tar.gz"
  sha256 "d360561de7ac97d05a6fc1dc0ca73d93c11a86234783dfd9ae92033300caabd7"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66911c32a9a82accb8d9bf52e6fca4e99ee7c0164b90ed09c328a8d9b3b2273c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c44039300363659390974308db020887206ccaa79546dcb8b2d4508fd3364a68"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d05fc604c1ce2042d898984469edaf7158b578c8f6b6d9927b6897508b966f89"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ce99faf30fa3422892be0c1ef9964e1bb8fb33918660ee080ccf33175297b75"
    sha256 cellar: :any_skip_relocation, ventura:       "77618aca2ece816736f2e4f90aeb4f3accdf22061fbb7fa38341b4cde535e841"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1ad607af2b4cf0db2599e5e6d59e4fcec79c9fd51629976e766fb527f23d430"
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
