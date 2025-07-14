class Fastly < Formula
  desc "Build, deploy and configure Fastly services"
  homepage "https://www.fastly.com/documentation/reference/cli/"
  url "https://github.com/fastly/cli/archive/refs/tags/v11.4.0.tar.gz"
  sha256 "843d73fb6079b431f40779aacdfe8eebb832241f250bcbf5225785146e1f3175"
  license "Apache-2.0"
  head "https://github.com/fastly/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "056d682b3a07e7ffbb668258549776c9a221b5a93fbc82a23e7f271fc0d4ae86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "056d682b3a07e7ffbb668258549776c9a221b5a93fbc82a23e7f271fc0d4ae86"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "056d682b3a07e7ffbb668258549776c9a221b5a93fbc82a23e7f271fc0d4ae86"
    sha256 cellar: :any_skip_relocation, sonoma:        "b5c29f69e76f6fe868daf77535c17defe09557962ae7571c037a00460bba8994"
    sha256 cellar: :any_skip_relocation, ventura:       "b5c29f69e76f6fe868daf77535c17defe09557962ae7571c037a00460bba8994"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9f606f192f41940df14f16231d21deb522eb9170ac97ec684f11b5186da7e96"
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
