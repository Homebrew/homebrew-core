class Fastly < Formula
  desc "Build, deploy and configure Fastly services"
  homepage "https://www.fastly.com/documentation/reference/cli/"
  url "https://github.com/fastly/cli/archive/refs/tags/v16.1.0.tar.gz"
  sha256 "24a42847712dab326c77d4ac1942478658392be2059f37bc7af642157092912d"
  license "Apache-2.0"
  head "https://github.com/fastly/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "468818fe39bb9028d98b10ed604040c8a798a6bb8f4009bf4699d08d6a1db539"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "468818fe39bb9028d98b10ed604040c8a798a6bb8f4009bf4699d08d6a1db539"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "468818fe39bb9028d98b10ed604040c8a798a6bb8f4009bf4699d08d6a1db539"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d993f9dba1c42ee555bb27aace24cb25b9977091a7b52bf84114591dea58a374"
    sha256 cellar: :any,                 x86_64_linux:      "04bd6a610449e90b0ff298ccc721cfab792792000418daec27ee11d3d48b0099"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    os = Utils.safe_popen_read("go", "env", "GOOS").strip
    arch = Utils.safe_popen_read("go", "env", "GOARCH").strip

    ldflags = %W[
      -X github.com/fastly/cli/pkg/revision.AppVersion=v#{version}
      -X github.com/fastly/cli/pkg/revision.GitCommit=#{tap.user}
      -X github.com/fastly/cli/pkg/revision.GoHostOS=#{os}
      -X github.com/fastly/cli/pkg/revision.GoHostArch=#{arch}
      -X github.com/fastly/cli/pkg/revision.Environment=release
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/fastly"

    generate_completions_from_executable(bin/"fastly", shell_parameter_format: "--completion-script-",
                                                       shells:                 [:bash, :zsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fastly version")

    ENV["FASTLY_API_TOKEN"] = "invalid-token"
    output = shell_output("#{bin}/fastly service list 2>&1", 1)
    assert_match "401 Unauthorized", output
  end
end
