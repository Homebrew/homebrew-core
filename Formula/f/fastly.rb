class Fastly < Formula
  desc "Build, deploy and configure Fastly services"
  homepage "https://www.fastly.com/documentation/reference/cli/"
  url "https://github.com/fastly/cli/archive/refs/tags/v16.2.0.tar.gz"
  sha256 "52e971b7ef0fd57ff6e751a7deb34843b5a3f591fce8b79e11c708b6a7bdd22b"
  license "Apache-2.0"
  head "https://github.com/fastly/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9fe3f7b1704b9a50cca85c27bfe54c259c56aa54d6bea4342c7f42920c0aeb1c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9fe3f7b1704b9a50cca85c27bfe54c259c56aa54d6bea4342c7f42920c0aeb1c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9fe3f7b1704b9a50cca85c27bfe54c259c56aa54d6bea4342c7f42920c0aeb1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c93648a140575b6abda943b2b2b87ea3c506f9c5d788c671aff43e1adfa87ea0"
    sha256 cellar: :any,                 x86_64_linux:      "06f4e293bf82c56bd85a3dd73c7b8c48902f9ec3b2f563fc49cab1796d2c4f10"
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
