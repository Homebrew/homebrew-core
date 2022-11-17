class Helix < Formula
  desc "Post-modern modal text editor"
  homepage "https://helix-editor.com"
  url "https://github.com/helix-editor/helix/releases/download/22.08.1/helix-22.08.1-source.tar.xz"
  sha256 "962cfb913b40b6b5e3896fce5d52590d83fa2e9c35dfba45fdfa26bada54f343"
  license "MPL-2.0"
  head "https://github.com/helix-editor/helix.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "f7f81ff6f6479a7d302d6d995e44c70a3c5553e6e096d9f95c0b119991511bd9"
    sha256 cellar: :any,                 arm64_monterey: "fbc0e33ba2b0639778b11efa751643c898d232d2021f363e1155c8fd30b48e2c"
    sha256 cellar: :any,                 arm64_big_sur:  "10fc0acae5c742ba3d3f95216f246a84160a072c9a300b8604ef32232047a606"
    sha256 cellar: :any,                 ventura:        "d73856b57749b0400cd9fe5252d6bdc9ccebf02df2d12cb11c33b930fcabb095"
    sha256 cellar: :any,                 monterey:       "0ffad064e6fe4c171025c18bab8d859244afca4fc3d6f338460111c9787fea2d"
    sha256 cellar: :any,                 big_sur:        "94834a7dc26269fbd95d35963b8fa7c871257fc508ec0dad3176373c3b7a40ff"
    sha256 cellar: :any,                 catalina:       "1312797458bebdd68994eb59c59da025fc5c1cce83d7650fdf8bcacf51159f59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a07db2941a93080fbc55d24138b22210fcfce512627552ccc3ecd3ebcbad0195"
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
