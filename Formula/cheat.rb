class Cheat < Formula
  desc "Create and view interactive cheat sheets for *nix commands"
  homepage "https://github.com/cheat/cheat"
  url "https://github.com/cheat/cheat.git",
    :tag      => "3.2.0",
    :revision => "f86633ca1cbd3abdbce2042b3e8f9c2a4a9fd5a0"

  bottle do
    cellar :any_skip_relocation
    sha256 "30d155c32058efaaaa7d06a8e8cebd52ed8418da09f136da497a3d750dbf27a0" => :catalina
    sha256 "75bc1350e6304cbcb7c0a6ceed7f070124be050d4eca2139945f34552305c677" => :mojave
    sha256 "21e172f4d076be3ada8c34132c6928a7fe22c64a499cc0b184374464e88f9e1b" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-mod", "vendor", "-o", bin/"cheat", "./cmd/cheat"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cheat --version")

    output = shell_output("#{bin}/cheat --init 2>&1")
    assert_match "editor: vim", output

    assert_match "could not locate config file", shell_output("#{bin}/cheat tar 2>&1", 1)
  end
end
