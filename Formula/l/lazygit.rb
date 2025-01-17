class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/refs/tags/v0.45.1.tar.gz"
  sha256 "ed5ec5aa94565a35bad77c69645dbdab96b9af0a10b07c17061f19dcf2b576d5"
  license "MIT"
  head "https://github.com/jesseduffield/lazygit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07892cf1f892cfb19269b3f091e9e7ceba6560d07ae59a0b18dff7aebcbfaccc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07892cf1f892cfb19269b3f091e9e7ceba6560d07ae59a0b18dff7aebcbfaccc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "07892cf1f892cfb19269b3f091e9e7ceba6560d07ae59a0b18dff7aebcbfaccc"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b879a2b6c92e98984d92612f1689852feb2fa97d9b4d79f4f3940decc41bf13"
    sha256 cellar: :any_skip_relocation, ventura:       "7b879a2b6c92e98984d92612f1689852feb2fa97d9b4d79f4f3940decc41bf13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0b4b9a535c84abe415967582828575af1e238cadf4657fa8cee912d44f83fd9"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.buildSource=homebrew"
    system "go", "build", "-mod=vendor", *std_go_args(ldflags:)
  end

  test do
    system "git", "init", "--initial-branch=main"

    output = shell_output("#{bin}/lazygit log 2>&1", 1)
    assert_match "errors.errorString terminal not cursor addressable", output

    assert_match version.to_s, shell_output("#{bin}/lazygit -v")
  end
end
