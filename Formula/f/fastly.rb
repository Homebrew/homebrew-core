class Fastly < Formula
  desc "Build, deploy and configure Fastly services"
  homepage "https://www.fastly.com/documentation/reference/cli/"
  url "https://github.com/fastly/cli/archive/refs/tags/v14.1.1.tar.gz"
  sha256 "fef9c102a20f6ef4554f915c67b2440ef6a8bb0d8dfbb6fd7ec0d0c915e301f1"
  license "Apache-2.0"
  head "https://github.com/fastly/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e114eb9d4f8ef4f2cb4c9e77d2aff13c7d2aad07eee3115ffaa7270e82c8df6c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e114eb9d4f8ef4f2cb4c9e77d2aff13c7d2aad07eee3115ffaa7270e82c8df6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e114eb9d4f8ef4f2cb4c9e77d2aff13c7d2aad07eee3115ffaa7270e82c8df6c"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8e0420231cfb2ebb249cdb3d4fd62599728828a091584b0e1211f3aa5070fbc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd1efe038fa8989f2944a864eea3c0771bd3d40442c6bc082ba1da282c691053"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7927901231d38517a57af82524c57d5dbf33c7ee26002547611b52dd8583902c"
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
