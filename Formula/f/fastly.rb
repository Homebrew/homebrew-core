class Fastly < Formula
  desc "Build, deploy and configure Fastly services"
  homepage "https://www.fastly.com/documentation/reference/cli/"
  url "https://github.com/fastly/cli/archive/refs/tags/v13.1.0.tar.gz"
  sha256 "732338087b184fc01990de61d27dbe6f64fc99e8abe07331dec87cdf5f06669e"
  license "Apache-2.0"
  head "https://github.com/fastly/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8a4a17b6703e31722eb8a57f2d3db834cafac7fcf35e5e3a9f68f6229b717e7d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a4a17b6703e31722eb8a57f2d3db834cafac7fcf35e5e3a9f68f6229b717e7d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a4a17b6703e31722eb8a57f2d3db834cafac7fcf35e5e3a9f68f6229b717e7d"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6efc94220696c3ea653c47a8596364b6e94d7d6b5c47301c4031421214517fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e772f90c0a0431456f23e8de858ec8f178a26b910bac861fa6cd69a6baf9745"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c1fd87b86749fdff68a23d766e94f051dcc3a53e36f7dea4d27b00f1e7b014f"
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
