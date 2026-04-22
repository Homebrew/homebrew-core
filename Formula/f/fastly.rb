class Fastly < Formula
  desc "Build, deploy and configure Fastly services"
  homepage "https://www.fastly.com/documentation/reference/cli/"
  url "https://github.com/fastly/cli/archive/refs/tags/v14.3.1.tar.gz"
  sha256 "b91f25494d3c773854388013078b9e3efde30ed661a6257708e105c4f6bc1368"
  license "Apache-2.0"
  head "https://github.com/fastly/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e70927a68725a7ce43e6793220a25fc17ee0afe047e954784cddca1fa1d3d75"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e70927a68725a7ce43e6793220a25fc17ee0afe047e954784cddca1fa1d3d75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e70927a68725a7ce43e6793220a25fc17ee0afe047e954784cddca1fa1d3d75"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1bab98bf19514744f379fcc5eadbb47ad5e92f46b8a4ef81279189911395a59"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b85600692b99076266e8eb95e52d8b107e9ddb1c384bc1ab66bdb308f7a08f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae66ccbb3d03adf21444143589e6aa3df98fb7dc8a404b9a96919021b8131cdb"
  end

  depends_on "go" => :build

  def install
    mv ".fastly/config.toml", "pkg/config/config.toml"

    os = Utils.safe_popen_read("go", "env", "GOOS").strip
    arch = Utils.safe_popen_read("go", "env", "GOARCH").strip

    ldflags = %W[
      -s -w
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
