class Fastly < Formula
  desc "Build, deploy and configure Fastly services"
  homepage "https://www.fastly.com/documentation/reference/cli/"
  url "https://github.com/fastly/cli/archive/refs/tags/v15.3.1.tar.gz"
  sha256 "6654c2078e903f25041364404b4d987a6777a8f902a4626ae4a891e371cb61b8"
  license "Apache-2.0"
  head "https://github.com/fastly/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9c114a8e8b8300b641509440fe11727d6f38d50a602ca8ea852bf3772724a7fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c114a8e8b8300b641509440fe11727d6f38d50a602ca8ea852bf3772724a7fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c114a8e8b8300b641509440fe11727d6f38d50a602ca8ea852bf3772724a7fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "feba15779fd4da726d3ff142a7ead7aebd8440d575153c4da4a27cae9be9cde0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22071c53e58ed7a9f022b8f4c4447c4cf8fb67ce0a2cbcedf3898d7cfc49ce3a"
    sha256 cellar: :any,                 x86_64_linux:  "09508c5739a232a5dc2f073a03663229cf77f096b4396690f78f6ae977b9a52b"
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
