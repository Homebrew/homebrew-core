class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.672.tar.gz"
  sha256 "12b92ab99e241ec84cd5f7535cfadc358bf44b22494b6b7b4dd8650a256fa229"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "23335a4fc4db82b83431f53b5b5ad6341ebc47e41aaa7c88eeb7a47cd39cad09"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a3b2c07fb760c4268941be5db0e75fdc9707d4d2f4d823ccb5369a9bbd0ac39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "731074e0d96063592786ce02712b947c96844643e8b180335a3246aef1eefa2b"
    sha256 cellar: :any_skip_relocation, sonoma:        "83c52c133103cab2593739b3226b39f35d9d0dc13eb5fbae80caa116bf4ab009"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71d9e24634b4bb8cf12794705ea0251cefac3ddb0091ce546465ac3818a7a920"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1280a88e2a48d08cae20afb432a9a8151b03a9176dd32d3e125e16d610494c4f"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -s -w
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppVersion=#{version}
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppBuildCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/ipsw"
    generate_completions_from_executable(bin/"ipsw", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ipsw version")

    assert_match "iPad Pro (12.9-inch) (6th gen)", shell_output("#{bin}/ipsw device-list")
  end
end
