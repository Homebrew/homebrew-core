class Gut < Formula
  desc "Beginner friendly porcelain for git"
  homepage "https://gut-cli.dev/"
  url "https://github.com/julien040/gut/archive/refs/tags/0.3.2.tar.gz"
  sha256 "49431ba0d24f9abf4c7cdbdf1956d2b6e70e16f955b5bbb70d8d8f4b8a5a48d1"
  license "MIT"
  head "https://github.com/julien040/gut.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ee60c94f64823edc247db7d64fac9c6f35c7f7c4c2e894e67a52f15148c0a0ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af0311402ae80932f3c55e62fffda6b731e0d191e0f0c14e35490e69803e04a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a2443c00f2a9e7bb81b0754add02c083455220aaf3cae06a041a10c3fb15434"
    sha256 cellar: :any_skip_relocation, sonoma:        "82951d3153c048316f7a5180df7160847b93cd7ca8491638b27ca5e3e7319c30"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55cadce09bb5c14fdf9e23ed605df31d4ec14d56503227f3fe098ff748a2d1f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9734fda07357cf7c57786fdb400b2be1363615dee08196472ffb0c1bcbcc3ee"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/julien040/gut/src/telemetry.gutVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"gut", shell_parameter_format: :cobra)
  end

  test do
    system bin/"gut", "telemetry", "disable"

    assert_match version.to_s, shell_output("#{bin}/gut --version")

    system "git", "init", "--initial-branch=main"
    system "git", "commit", "--allow-empty", "-m", "test"
    assert_match "on branch main", shell_output("#{bin}/gut whereami")
  end
end
