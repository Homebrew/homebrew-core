class Fastly < Formula
  desc "Build, deploy and configure Fastly services"
  homepage "https://www.fastly.com/documentation/reference/cli/"
  url "https://github.com/fastly/cli/archive/refs/tags/v17.2.0.tar.gz"
  sha256 "9814c0990a68142fbf2e50007eecdd17be368d0dee2b636ca060311a0af6067e"
  license "Apache-2.0"
  head "https://github.com/fastly/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "de8332030c88f1e9cdc3828f7fa8155bee764a5cbb5aefed11e1582227e6be2c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "de8332030c88f1e9cdc3828f7fa8155bee764a5cbb5aefed11e1582227e6be2c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "de8332030c88f1e9cdc3828f7fa8155bee764a5cbb5aefed11e1582227e6be2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "61bd4c302b42e275aadca298ab2ec63cdc7129a46b3ece548d28e20d1c7d3059"
    sha256 cellar: :any,                 x86_64_linux:      "240bebe5f16ca2509f016cbc582b90df603a719c8c3682bce741c68a6d9e64bd"
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
