class Nanobot < Formula
  desc "Build MCP Agents"
  homepage "https://www.nanobot.ai/"
  url "https://github.com/nanobot-ai/nanobot/archive/refs/tags/v0.0.68.tar.gz"
  sha256 "f6c2569012e3cb98e17162c08eec039a0f4be919cf15832be74ab874f33a9c11"
  license "Apache-2.0"
  head "https://github.com/nanobot-ai/nanobot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "28f0a1eedc56152f2cf3d7c5d6ca50143470bc52010a399e4af862698e3c9a8c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a2d68495e8914efe995d09a4f3790a78a240e80bed3b108c3f21ceee99bbce7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc597774ebda6c129b4fa8a3631ac881358aa3f99440db8384ab069042bd3237"
    sha256 cellar: :any_skip_relocation, sonoma:        "457bb683c28d187045903232c131251a34613cc47dc63714c5114dcb51230aa8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ef9def686ca4ad4617a386c5a5bd38e1a85bb2db5c425cebf64b60e3fa6a834"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08b208f790b23a7da6dedb446abb23cbf296a46324971d60df223bb8a8474eb8"
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
