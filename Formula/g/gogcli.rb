class Gogcli < Formula
  desc "Google Suite CLI"
  homepage "https://gogcli.sh"
  url "https://github.com/openclaw/gogcli/archive/refs/tags/v0.39.0.tar.gz"
  sha256 "a0da5e6d582472b0d6164382d8307ede289cfbc51c329e9985a505a4c2d31a49"
  license "MIT"
  head "https://github.com/openclaw/gogcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de27d09217baaed2c8e97e52f42c39f10469330734c3f314b0bf0cb8fdf701f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f68c01bd2575f07533c1d23783e5ee9b513f001fbeeebb5bba6d431c00649c7d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb4d8066f0bfdbbe1e328b84bd1d0595130e00ddddd85b9c9f846f01c3aa9d60"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "77e26c8789a87fa2ad86039108f4d0b61152381edacd47b666320c736852cfd0"
    sha256 cellar: :any,                 x86_64_linux:  "121d0a71ba2e85436056c1e5acdf6ae2354b1775e4a01c427a4a0ff67ddbdac7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/steipete/gogcli/internal/cmd.version=#{version}
      -X github.com/steipete/gogcli/internal/cmd.commit=#{tap.user}
      -X github.com/steipete/gogcli/internal/cmd.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"gog"), "./cmd/gog"

    generate_completions_from_executable(bin/"gog", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gog --version")

    ENV["GOG_ACCOUNT"] = "example@example.com"
    output = shell_output("#{bin}/gog drive ls 2>&1", 10)
    assert_match "OAuth client credentials missing", output
  end
end
