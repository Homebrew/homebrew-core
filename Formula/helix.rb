class Helix < Formula
  desc "Post-modern modal text editor"
  homepage "https://helix-editor.com"
  url "https://github.com/helix-editor/helix/releases/download/22.08.1/helix-22.08.1-source.tar.xz"
  sha256 "962cfb913b40b6b5e3896fce5d52590d83fa2e9c35dfba45fdfa26bada54f343"
  license "MPL-2.0"
  head "https://github.com/helix-editor/helix.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "57090f185674bf3809d1f8404b6051492028029015ea0ac21574002b45619c7c"
    sha256 cellar: :any, arm64_big_sur:  "cc27d03f9a2ae50301bb52161042418de48efebbb5b287aac7d1ccad5ad544c3"
    sha256 cellar: :any, monterey:       "e02c39d4f04e682ff8428cbec64b1ce56182745c2b93f8e2104b7b76c6caba48"
    sha256 cellar: :any, big_sur:        "cab72badae4e61751b591f5b905f4968fb6296be4fe440597e23d1021ba06424"
    sha256 cellar: :any, catalina:       "0d1b0d5952923c20c40ef596a159a046b3c615fa7a27f527c27325dda7e21b36"
    sha256               x86_64_linux:   "661f36d16415f7d17a21494fe7a536c12e25da93c64a240f6822da5e68397ec9"
  end

  depends_on "rust" => :build

  fails_with gcc: "5" # For C++17

  def install
    system "cargo", "install", "-vv", *std_cargo_args(root: libexec, path: "helix-term")
    rm_r "runtime/grammars/sources/"
    libexec.install "runtime"

    (bin/"hx").write_env_script(libexec/"bin/hx", HELIX_RUNTIME: libexec/"runtime")

    bash_completion.install "contrib/completion/hx.bash" => "hx"
    fish_completion.install "contrib/completion/hx.fish"
    zsh_completion.install "contrib/completion/hx.zsh" => "_hx"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hx -V")
    assert_match "✓", shell_output("#{bin}/hx --health")
  end
end
