class Fastly < Formula
  desc "Build, deploy and configure Fastly services"
  homepage "https://www.fastly.com/documentation/reference/cli/"
  url "https://github.com/fastly/cli/archive/refs/tags/v17.1.0.tar.gz"
  sha256 "1327d5aa61e572b34535501f32ee730fe7ce54f0f26422d7b04862963f4fa7a8"
  license "Apache-2.0"
  head "https://github.com/fastly/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "900dc605df9326475b738bd60396888ec7f5a42677c209a22da4756b00ed94bf"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "900dc605df9326475b738bd60396888ec7f5a42677c209a22da4756b00ed94bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "900dc605df9326475b738bd60396888ec7f5a42677c209a22da4756b00ed94bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "edfff7258a2e7c2888e872407dca84d23f23a1e2820f8f23b43e2f538dac0e6d"
    sha256 cellar: :any,                 x86_64_linux:      "c260230e2cb72331e4ae767af643326c2f9a014282f78b55965d2b62055b365a"
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
