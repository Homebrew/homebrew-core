class Cheat < Formula
  desc "Create and view interactive cheat sheets for *nix commands"
  homepage "https://github.com/cheat/cheat"
  url "https://github.com/cheat/cheat/archive/3.10.0.tar.gz"
  sha256 "1e09b312ba76e548bd0ad3d97711a56cc928d19dbfee7c3452345091df066c98"

  bottle do
    cellar :any_skip_relocation
    sha256 "f04ac974103ada29d97ea5fcf7cf80b698973d8af84417fe85a2fb8dec84eb72" => :catalina
    sha256 "21f3a7c5784bbfb62b3f3f70b53259b1e1b070505e6795d6f4dc416aa9dbded7" => :mojave
    sha256 "ffa6aeb539b5b9c42520b243d8917b67f89a851a8d1457369b0a72f7ca0ceef3" => :high_sierra
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
