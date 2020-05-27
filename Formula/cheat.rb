class Cheat < Formula
  desc "Create and view interactive cheat sheets for *nix commands"
  homepage "https://github.com/cheat/cheat"
  url "https://github.com/cheat/cheat/archive/3.10.1.tar.gz"
  sha256 "e87c5352e74d7644f9138e7a56f00872ce73ec1e57dbdc6836a05fee939236d6"

  bottle do
    cellar :any_skip_relocation
    sha256 "43d5bce2836980ecfe6234ec68b5869655419ef2df558254c9d47ceda5e620d1" => :catalina
    sha256 "d73890166e1ec3487c8046e235d17e0b39cc7bec5cd3b9f4519d59dd38baafab" => :mojave
    sha256 "2b62a0465ebeb2a263f32e75f4dd780e4eba1223757e336227a8ac071eb935de" => :high_sierra
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
