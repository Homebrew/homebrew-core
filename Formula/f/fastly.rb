class Fastly < Formula
  desc "Build, deploy and configure Fastly services"
  homepage "https://www.fastly.com/documentation/reference/cli/"
  url "https://github.com/fastly/cli/archive/refs/tags/v12.1.0.tar.gz"
  sha256 "f00a924e51afcb177aac08b324f5d0e6b3fd96a409c8b62d38e2dc9e62c76294"
  license "Apache-2.0"
  head "https://github.com/fastly/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a755774b693c4a48112e89419e110c3c95e7ffcff94ce26d848d8d9ba61bf84d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a755774b693c4a48112e89419e110c3c95e7ffcff94ce26d848d8d9ba61bf84d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a755774b693c4a48112e89419e110c3c95e7ffcff94ce26d848d8d9ba61bf84d"
    sha256 cellar: :any_skip_relocation, sonoma:        "0208f5fe1eb0c6188ae237fbdb59267d5c95e885e732b6d717099dd5c7facd02"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18b63df4c5a96be1c78f5f326634adeca2902dbd878a105e67f0d6530f7bc621"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0457c884d8d585dcbf0b2fc122eb7b279c870d5eb3e7d1d99eac280e8b8e522"
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

    output = shell_output("#{bin}/fastly service list 2>&1", 1)
    assert_match "Fastly API returned 401 Unauthorized", output
  end
end
