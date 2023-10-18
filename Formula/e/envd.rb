class Envd < Formula
  desc "Reproducible development environment for AI/ML"
  homepage "https://envd.tensorchord.ai"
  url "https://github.com/tensorchord/envd/archive/v0.3.40.tar.gz"
  sha256 "3923fad229064604c3539d0b03de7a4491962a7e724df748cdf84aaa817b319a"
  license "Apache-2.0"
  head "https://github.com/tensorchord/envd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "93aa35dee3290ad62d6399a0a0b5a7da16de66ee37671b27cd6aa7573d847f47"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d09e92d281df3aa5a70a3e4fd5e2062f4abb6b6892404bc8e8981f07e6947886"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "84036e95c70396fd7328f15c3508247def2c739a6f5ccf07fe157bd137259788"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "438e989b081c8bae164fc4daa1e43f50c648699d996b49d3ee1b766a4aad8990"
    sha256 cellar: :any_skip_relocation, sonoma:         "967108140ef912cfc7eb117f836670dee16092005024595bc37affca7831db04"
    sha256 cellar: :any_skip_relocation, ventura:        "39fd97edde76168f9bca689f683f447bb935a83fa1db91fb04c78d1fe1576787"
    sha256 cellar: :any_skip_relocation, monterey:       "23033fc133f5318c95001b62e5285b0b2fc28859aecc3ce5b5f1c4955fb02af2"
    sha256 cellar: :any_skip_relocation, big_sur:        "dadd7bd9411b901e6b33ac0e1d967d76f96b08fc410f2c0fc32132bcae3b7e66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "454818164c5842db2c85d7db94cfc48bd24235ae2058da62621a2a5eda734093"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/tensorchord/envd/pkg/version.buildDate=#{time.iso8601}
      -X github.com/tensorchord/envd/pkg/version.version=#{version}
      -X github.com/tensorchord/envd/pkg/version.gitTag=v#{version}
      -X github.com/tensorchord/envd/pkg/version.gitCommit=#{tap.user}
      -X github.com/tensorchord/envd/pkg/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/envd"
    generate_completions_from_executable(bin/"envd", "completion", "--no-install",
                                         shell_parameter_format: "--shell=",
                                         shells:                 [:bash, :zsh, :fish])
  end

  test do
    output = shell_output("#{bin}/envd version --short")
    assert_equal "envd: v#{version}", output.strip

    expected = if OS.mac?
      "failed to list containers: Cannot connect to the Docker daemon"
    else
      "failed to list containers: Got permission denied while trying to connect to the Docker daemon"
    end

    stderr = shell_output("#{bin}/envd env list 2>&1", 1)
    assert_match expected, stderr
  end
end
