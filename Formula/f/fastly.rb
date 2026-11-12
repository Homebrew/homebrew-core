class Fastly < Formula
  desc "Build, deploy and configure Fastly services"
  homepage "https://www.fastly.com/documentation/reference/cli/"
  url "https://github.com/fastly/cli/archive/refs/tags/v17.1.0.tar.gz"
  sha256 "1327d5aa61e572b34535501f32ee730fe7ce54f0f26422d7b04862963f4fa7a8"
  license "Apache-2.0"
  head "https://github.com/fastly/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c6d601b1a3daa49e97d0ce05a664ce048a577af775c94d0c72f9d4e1bf1c8e5b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c6d601b1a3daa49e97d0ce05a664ce048a577af775c94d0c72f9d4e1bf1c8e5b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c6d601b1a3daa49e97d0ce05a664ce048a577af775c94d0c72f9d4e1bf1c8e5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fe28c059a7f86497ca444eb490197f28e20f128896ed6e45a40288bc217cd6c8"
    sha256 cellar: :any,                 x86_64_linux:      "ce8514129542d18000b2af4f2ac514a312cff1ecc272b996869b57051fbecd05"
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
