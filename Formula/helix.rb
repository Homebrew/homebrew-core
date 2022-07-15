class Helix < Formula
  desc "Post-modern modal text editor"
  homepage "https://helix-editor.com"
  url "https://github.com/helix-editor/helix/releases/download/22.05/helix-22.05-source.tar.xz"
  sha256 "b5de56c98fcc177cb06ac802c7f466e069743f3dcd09d3910f4c08bead9c52ef"
  license "MPL-2.0"
  head "https://github.com/helix-editor/helix.git", branch: "master"

  depends_on "rust" => :build

  on_linux do
    depends_on "gcc" # For C++17
  end

  fails_with gcc: "5"

  def install
    system "cargo", "install", "-vv", *std_cargo_args(root: libexec, path: "helix-term")
    libexec.install "runtime"

    (bin/"hx").write_env_script(libexec/"bin/hx", HELIX_RUNTIME: libexec/"runtime")

    bash_completion.install "contrib/completion/hx.bash" => "hx"
    fish_completion.install "contrib/completion/hx.fish"
    zsh_completion.install "contrib/completion/hx.zsh" => "_hx"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hx -V")
    assert_match "post-modern text editor", shell_output("#{bin}/hx -h")
  end
end
