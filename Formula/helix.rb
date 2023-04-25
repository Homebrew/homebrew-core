class Helix < Formula
  desc "Post-modern modal text editor"
  homepage "https://helix-editor.com"
  url "https://github.com/helix-editor/helix/releases/download/23.03/helix-23.03-source.tar.xz"
  sha256 "60e5d8927f2f43807ff4ed3c96e7071746ce23d0b7ebaa27e380723726710703"
  license "MPL-2.0"
  head "https://github.com/helix-editor/helix.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1f1a431df3efe823df3b3905f0bf3c8ac8bf28a374df5b66363c2c4e6115b7fc"
    sha256 cellar: :any,                 arm64_monterey: "f9456c6acbdc9706ecbe936bee549624cec6149ba8cacd940b93426ab2987b6b"
    sha256 cellar: :any,                 arm64_big_sur:  "c1a6a23839017a74767a188b8d937e4ef6d41442c2997c23098209f2769cdeac"
    sha256 cellar: :any,                 ventura:        "d1f3d99486edcc3b95ec5aeb205815020e0ce25f20340427c429f1f2eb4c8891"
    sha256 cellar: :any,                 monterey:       "4a29b97dcccd03067764b8478d4c41c6a7a8e52a21440f9c08e15c29ab7b6052"
    sha256 cellar: :any,                 big_sur:        "15d34c5105e8c2672594446b3a372e7ab458ce985c6dda4ce7b5bcfe72969881"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a996a20a3c9e045579f9c0bab62c64d0989f77bdc34608d87d07e163a6b6dcac"
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
