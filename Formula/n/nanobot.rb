class Nanobot < Formula
  desc "Build MCP Agents"
  homepage "https://www.nanobot.ai/"
  url "https://github.com/nanobot-ai/nanobot/archive/refs/tags/v0.0.73.tar.gz"
  sha256 "98f7a049dfbfbfe8e2ed2d5cd3e26af2bb56c6b4a4fc4e2c4546ce96799965ca"
  license "Apache-2.0"
  head "https://github.com/nanobot-ai/nanobot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b381667f32b018156acbde9f22f12932fca6b1c7e883f66986e7ebd36803be78"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b411480147fb1576bc19830ea6e670fa7a7dbda303d75d95ae24b479e6d98b3c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6af8d44ee98e39351c62845c7b13921ce19bb3ddd3cbb2e3e7094f3c9c78c823"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e37e1da96b46e97f3c32db11e31892af6492f4fbd5f0c4e0aad3e10b8868493"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29341afdd864875c4d4c5320b85c9c456e5534b39aef56594f7cb96455aaa79e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51811fec31471df1c14878f457b2c38ed75ae8617396f0dbea5a9b7cb70aa882"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/nanobot-ai/nanobot/pkg/version.Tag=v#{version}
      -X github.com/nanobot-ai/nanobot/pkg/version.BaseImage=ghcr.io/nanobot-ai/nanobot:v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"nanobot", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nanobot --version")

    pid = spawn bin/"nanobot", "run"
    sleep 1
    assert_path_exists testpath/"nanobot.db"
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
