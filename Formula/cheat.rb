class Cheat < Formula
  desc "Create and view interactive cheat sheets for *nix commands"
  homepage "https://github.com/cheat/cheat"
  url "https://github.com/cheat/cheat/archive/4.0.1.tar.gz"
  sha256 "98242fa3efd4b5fd57d6ad7e69a2570e7defacb580e30ae274deec3e1939f494"

  bottle do
    cellar :any_skip_relocation
    sha256 "4ed11a1db2629f73844a9707d0b01a3995b3cfc07d5dbeb7b07763bdfdeadd23" => :catalina
    sha256 "7214cd69926ce3339c194fb22db34215519bc5f5314cafd64b730436cd545a68" => :mojave
    sha256 "cfd7c2862fb6180e362a45a6dc142e9c3b8ae524d9c0105cfc7f963812ef22d8" => :high_sierra
  end

  depends_on "go" => :build

  conflicts_with "bash-snippets", :because => "Both install a `cheat` executable"

  def install
    system "go", "build", "-mod", "vendor", "-o", bin/"cheat", "./cmd/cheat"

    bash_completion.install "scripts/cheat.bash"
    fish_completion.install "scripts/cheat.fish"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cheat --version")

    output = shell_output("#{bin}/cheat --init 2>&1")
    assert_match "editor: vim", output
  end
end
