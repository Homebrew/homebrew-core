class Helix < Formula
  desc "Post-modern modal text editor"
  homepage "https://helix-editor.com"
  url "https://github.com/helix-editor/helix/releases/download/22.05/helix-22.05-source.tar.xz"
  sha256 "b5de56c98fcc177cb06ac802c7f466e069743f3dcd09d3910f4c08bead9c52ef"
  license "MPL-2.0"
  head "https://github.com/helix-editor/helix.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "aec80ee34af08aa6a66782f58a280c5de3cdf30057eda4e9180b67a8762f06e7"
    sha256 cellar: :any, arm64_big_sur:  "d703cd9935cc5b8ab412ac243213e0b4e3fd043932ad2694c94b81cbb0ff51bd"
    sha256 cellar: :any, monterey:       "fd23f12160f10676dd9b618dd492bbf5f0ba198f88c290db6628ae2341ed16e1"
    sha256 cellar: :any, big_sur:        "8b173676046ad2d6e335da356d18e9ac61dee3ba994f47546ed6aa3041ae5d38"
    sha256 cellar: :any, catalina:       "5c6f80440d9028c97f63365832ab563b74b4c07c811542b335c25a7ef7d870dd"
    sha256               x86_64_linux:   "85bde91e1b582a795b17d5dec43195bdae8e22d5af28318055a446f48ffc79b6"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "gcc" # For C++17
  end

  fails_with gcc: "5"

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
    assert_match "post-modern text editor", shell_output("#{bin}/hx -h")
  end
end
