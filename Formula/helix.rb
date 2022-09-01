class Helix < Formula
  desc "Post-modern modal text editor"
  homepage "https://helix-editor.com"
  url "https://github.com/helix-editor/helix/releases/download/22.08/helix-22.08-source.tar.xz"
  sha256 "2c96c00d2c7df98d4426884ee3b217aaadb985f3301f5399e2436db6440373a3"
  license "MPL-2.0"
  head "https://github.com/helix-editor/helix.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "a815b3634f2b1eb25a4fa514782b651a040296e9939f4a686dc7e0f2e0b09a5a"
    sha256 cellar: :any, arm64_big_sur:  "20da33abeeeaf6d19c81e3bd0f3ed9d1f84d43cfbb665a9f10d8a5cf639d18d6"
    sha256 cellar: :any, monterey:       "35981587b197d779f78f9567696a7dd96d86cd26511e0ce495e4e9f62f49425b"
    sha256 cellar: :any, big_sur:        "4d761ce6d471151cfa59a758d3631e9ff5ee81eab5d829b91b1e71c0982a20fe"
    sha256 cellar: :any, catalina:       "73a2306487607f332a3c7930dda569e079082becd91d4ed4ca0ad74747f43c30"
    sha256               x86_64_linux:   "24ed8348b200e6700b0afe48349e880a2ccc69a6a911bda9c48eff238c3e978e"
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
    assert_match "✔", shell_output("#{bin}/hx --health")
  end
end
