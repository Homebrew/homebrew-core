class Incus < Formula
  desc "CLI client for interacting with Incus"
  homepage "https://linuxcontainers.org/incus"
  url "https://linuxcontainers.org/downloads/incus/incus-6.8.tar.xz"
  sha256 "19be50514acd845ceab62cbdb34cd7a9a6782e1e063f334245135be8db0f0489"
  license "Apache-2.0"
  head "https://github.com/lxc/incus.git", branch: "main"

  livecheck do
    url "https://linuxcontainers.org/incus/downloads/"
    regex(/href=.*?incus[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44913f8cad662c918fdfd54f5918cd957cc802d7d688b1354731a51a4d724f4a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44913f8cad662c918fdfd54f5918cd957cc802d7d688b1354731a51a4d724f4a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "44913f8cad662c918fdfd54f5918cd957cc802d7d688b1354731a51a4d724f4a"
    sha256 cellar: :any_skip_relocation, sonoma:        "5572a23e152d30eb8c65dcdab61aa96434826fd493df67992ff000a22a154e15"
    sha256 cellar: :any_skip_relocation, ventura:       "5572a23e152d30eb8c65dcdab61aa96434826fd493df67992ff000a22a154e15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ebe389630792b0ec0fce294a516433c0d70c5f863f11b8d6b46fe3ddba876a0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/incus"

    generate_completions_from_executable(bin/"incus", "completion")
  end

  test do
    output = JSON.parse(shell_output("#{bin}/incus remote list --format json"))
    assert_equal "https://images.linuxcontainers.org", output["images"]["Addr"]

    assert_match version.to_s, shell_output("#{bin}/incus --version")
  end
end
