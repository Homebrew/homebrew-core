class Helix < Formula
  desc "Post-modern modal text editor"
  homepage "https://helix-editor.com"
  url "https://github.com/helix-editor/helix/releases/download/23.05/helix-23.05-source.tar.xz"
  sha256 "c1ca69facde99d708175c686ce5bf3585e119e372c83e1c3dc1d562c7a8e3d87"
  license "MPL-2.0"
  head "https://github.com/helix-editor/helix.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "bd40b4751765df4dbae46c4a014d033b5a5428aaeac13fe277a569516cbb82de"
    sha256 cellar: :any,                 arm64_monterey: "8d304cac9406203074f151b77df1a72e985f1e4e6573f2d1ab94706a90e3fac2"
    sha256 cellar: :any,                 arm64_big_sur:  "11b879bf0dcf0ccbcf6a4377ba949ec70bc9f149465282abfa1750ea947cdaaf"
    sha256 cellar: :any,                 ventura:        "ee131ad851144fdacfb48848a9c8a9370d4da586962ef9ba24dde74adf77261f"
    sha256 cellar: :any,                 monterey:       "330c56170f9af4fb38cd20925198ac92a430eb980db2ac6a14d6851e9cce7e4c"
    sha256 cellar: :any,                 big_sur:        "7bd477b8d2827682263498884db7855474609b744eac00df48f8d5b2483605ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7afb2304044a713719d335ccc870e5dd311118a229da312c4122b362a8e42bb"
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
