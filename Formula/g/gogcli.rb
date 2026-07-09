class Gogcli < Formula
  desc "Google Suite CLI"
  homepage "https://gogcli.sh"
  url "https://github.com/openclaw/gogcli/archive/refs/tags/v0.33.0.tar.gz"
  sha256 "cc25034116e950e8461cfd629ee0fc500292b52297830653337d940e00d9353c"
  license "MIT"
  head "https://github.com/openclaw/gogcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bd3eba4657314e45f3fc04272aa4a04608fce3f749c6a557536e6235ad68be9d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "196863682da3f9081a1ed7ab26f1d67b311575dd041e35a415be1af4acf04214"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "260ec3b4cf366072ef9856a44c8df0a1f5a9e0af405fb575eb5a1caba77f979c"
    sha256 cellar: :any_skip_relocation, sonoma:        "e21109fe1b8198aa5f445e634eb15a6aadd4229209d7af60da6651053ceb5080"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e03845cc639adc6e71697d1c6bd2002d20184edda4130a70da81ed61425b25d"
    sha256 cellar: :any,                 x86_64_linux:  "5e76a72128eb54553b3534ab46a61fc26e66b8558f795b1f04bce3d123c3731d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
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
