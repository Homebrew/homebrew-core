class Gickup < Formula
  desc "Backup all your repositories with Ease"
  homepage "https://cooperspencer.github.io/gickup-documentation/"
  url "https://github.com/cooperspencer/gickup/archive/refs/tags/v0.10.45.tar.gz"
  sha256 "61cb2fef81f719bdf4bce8061aae2a0280985e13e194121455ffbfb4d2cfce24"
  license "Apache-2.0"
  head "https://github.com/cooperspencer/gickup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e1586abdf7bfa7dd0af34f71a5a8945fb6597027c1e1627adbd029b0533a577f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "632e67a9e877fd61a56cb2e9d0113c796836ba09dfa05f4d5be74e773f1e8a3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3402fd4096eec4fca03a862f631d44e7eaf353951aaefe07c1f71b30a6e9654f"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0f5feae3a42c79d6e5435308bd7df0c45d4f49312f93db7bfc09d8d474f366e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5003dae48a7adf9411e7fa24783626babc08e5b68897decb17314eaccf26da8d"
    sha256 cellar: :any,                 x86_64_linux:  "187f44f4270b28979bcaa3a8ce7b91715e3c218d68f46c77785a96561b6a29ff"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    (testpath/"conf.yml").write <<~YAML
      source:
        github:
          - token: brewtest-token
            user: Brew Test
            username: brewtest
            password: testpass
            ssh: true
    YAML

    output = shell_output("#{bin}/gickup --dryrun 2>&1", 1)
    assert_match "grabbing the repositories from Brew Test", output

    assert_match version.to_s, shell_output("#{bin}/gickup --version")
  end
end
