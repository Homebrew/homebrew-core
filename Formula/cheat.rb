class Cheat < Formula
  desc "Create and view interactive cheat sheets for *nix commands"
  homepage "https://github.com/cheat/cheat"
  url "https://github.com/cheat/cheat/archive/4.0.1.tar.gz"
  sha256 "98242fa3efd4b5fd57d6ad7e69a2570e7defacb580e30ae274deec3e1939f494"

  bottle do
    cellar :any_skip_relocation
    sha256 "22e47b7e9dfb461e2e9f8c3dac9ead9fe261026a0f4b4ce2b89f490253ea2962" => :catalina
    sha256 "c46bf0a127b1fd10e45b26e4fdf88333228f9d230f71190580891acd64a2a7bd" => :mojave
    sha256 "78d1fc2437cda33d65afab69eadf4870afcb0ac7a0ff6fbe55ede0af982d52a7" => :high_sierra
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
