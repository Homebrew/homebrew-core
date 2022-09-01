class Helix < Formula
  desc "Post-modern modal text editor"
  homepage "https://helix-editor.com"
  url "https://github.com/helix-editor/helix/releases/download/22.08/helix-22.08-source.tar.xz"
  sha256 "2c96c00d2c7df98d4426884ee3b217aaadb985f3301f5399e2436db6440373a3"
  license "MPL-2.0"
  head "https://github.com/helix-editor/helix.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_monterey: "bfa8198fe484669ed9bee6be575a93e79451f112214147013739c232f95f0531"
    sha256 cellar: :any, arm64_big_sur:  "c5966cb5521dbca6dad609bd57767b1826a18db65b52190e40d4bb0448ad6b76"
    sha256 cellar: :any, monterey:       "12996cafbaa40a593e0429245d25713390c376e5af2dab34d132807cdcd5aa24"
    sha256 cellar: :any, big_sur:        "7088232ccdf1527cf46cd308a2fea54aa5a25d5505d0c80df8bc77999848e7d1"
    sha256 cellar: :any, catalina:       "7820c24284da2efaf408a0352d8b1a12364c026dea2ad4c5e69a4f27fab66a0b"
    sha256               x86_64_linux:   "383904b4596b7a296c0687f0c0b1168890327f0a7683d63d0e599058a9e4fba8"
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
