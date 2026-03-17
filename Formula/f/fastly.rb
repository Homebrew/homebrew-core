class Fastly < Formula
  desc "Build, deploy and configure Fastly services"
  homepage "https://www.fastly.com/documentation/reference/cli/"
  url "https://github.com/fastly/cli/archive/refs/tags/v14.1.0.tar.gz"
  sha256 "bc6f82a71812d1a6964c321a94a9882f4cdd8b21156e781ed78946be794651e6"
  license "Apache-2.0"
  head "https://github.com/fastly/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e6e3957d6de868b75f696aa1a366271e765b44ba3a5c0841e767e040edabd910"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6e3957d6de868b75f696aa1a366271e765b44ba3a5c0841e767e040edabd910"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e6e3957d6de868b75f696aa1a366271e765b44ba3a5c0841e767e040edabd910"
    sha256 cellar: :any_skip_relocation, sonoma:        "00fd593ebe26c39dd3e10201f65ee45b991231ecd9648dcfae64b7323635c2e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0bea0e2e9efeaed76b4826bbc696b5265a6d52b3647264d208c5a57032798ccc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "133c05028c14541d72c61f2237821abc2b1bccb58d8e9d6d44625fff3c9892be"
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
