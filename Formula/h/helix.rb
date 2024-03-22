class Helix < Formula
  desc "Post-modern modal text editor"
  homepage "https://helix-editor.com"
  url "https://github.com/helix-editor/helix/releases/download/23.10/helix-23.10-source.tar.xz"
  sha256 "4e7bcac200b1a15bc9f196bdfd161e4e448dc670359349ae14c18ccc512153e8"
  license "MPL-2.0"
  head "https://github.com/helix-editor/helix.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "dee02487f9c105a18817a0f197ed19f325b42b2c40bf514ccdcd2655af8ce0be"
    sha256 cellar: :any,                 arm64_ventura:  "356bd6411fc9c63961a53670d1ef037e6514199e2da7f323a5c61359263ca8c4"
    sha256 cellar: :any,                 arm64_monterey: "c76e8f748ac49510a80cd2694bf64bbf5851ec88ec824e46f55557c92d337ec9"
    sha256 cellar: :any,                 sonoma:         "660b93003f12d892ff04b52bb0e16e6b32bdd082f4a84d0ec4a08fe4a495ae41"
    sha256 cellar: :any,                 ventura:        "bb7706f9cc929cec273b8dfcdf850a5af1c9319035d675e2134466d13b9e68db"
    sha256 cellar: :any,                 monterey:       "2259dff225e211d439c4da877102883dc339843b5c1151c02eedc8b27d09a207"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "529cf06bde429542b516cdf91972d8204c1049eb9f414b79b906320bde68386f"
  end

  depends_on "rust" => :build

  fails_with gcc: "5" # For C++17

  def install
    ENV["HELIX_DEFAULT_RUNTIME"] = libexec/"runtime"
    system "cargo", "install", "-vv", *std_cargo_args(path: "helix-term")
    rm_r "runtime/grammars/sources/"
    libexec.install "runtime"

    bash_completion.install "contrib/completion/hx.bash" => "hx"
    fish_completion.install "contrib/completion/hx.fish"
    zsh_completion.install "contrib/completion/hx.zsh" => "_hx"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hx -V")
    assert_match "✓", shell_output("#{bin}/hx --health")
  end
end
