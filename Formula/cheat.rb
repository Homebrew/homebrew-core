class Cheat < Formula
  desc "Create and view interactive cheat sheets for *nix commands"
  homepage "https://github.com/cheat/cheat"
  url "https://github.com/cheat/cheat/archive/4.2.1.tar.gz"
  sha256 "2a63b18bf8d55b865606f4be91af3650aacff70b8c9b8729661d60323367d455"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "441d725fd05398bb4bb7010d192acaba572fb422925c838192c284b4a2df4462"
    sha256 cellar: :any_skip_relocation, big_sur:       "0f6bfd612dd9d9de05ec3ecec8de402383855e1ab8bd10bd26180abc29d39ad6"
    sha256 cellar: :any_skip_relocation, catalina:      "c635e1e6108ac066791cc64e613906729297a85c3326f5dda876c417c3bd5f02"
    sha256 cellar: :any_skip_relocation, mojave:        "14f1f0861484d6a340d79779592ade42f3665aad8843ae14ce8b637a61e2a1bb"
  end

  depends_on "go" => :build

  conflicts_with "bash-snippets", because: "both install a `cheat` executable"

  def install
    system "go", "build", "-mod", "vendor", "-o", bin/"cheat", "./cmd/cheat"

    bash_completion.install "scripts/cheat.bash"
    fish_completion.install "scripts/cheat.fish"
    zsh_completion.install "scripts/cheat.zsh"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cheat --version")

    output = shell_output("#{bin}/cheat --init 2>&1")
    assert_match "editor: vim", output
  end
end
