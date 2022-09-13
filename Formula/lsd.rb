class Lsd < Formula
  desc "Clone of ls with colorful output, file type icons, and more"
  homepage "https://github.com/Peltoche/lsd"
  url "https://github.com/Peltoche/lsd/archive/0.23.1.tar.gz"
  sha256 "9698919689178cc095f39dcb6a8a41ce32d5a1283e6fe62755e9a861232c307d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d9118a00072f09bfbe0389b32f10e744dcd4265f7a73c51a2d7baa163ed86dc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "955c94b02d2e099be742ea7d1b84e95a6334b73d2ef57b7e4fd297d33062c64e"
    sha256 cellar: :any_skip_relocation, monterey:       "316f690ace642dafe8d44930f852a222dc6c9bd412d76799ade1e5425c66feec"
    sha256 cellar: :any_skip_relocation, big_sur:        "512dac8d55eaaec38b23d065c22e2074feaa6a70a615d2b62c62aae261287d20"
    sha256 cellar: :any_skip_relocation, catalina:       "ad682aeca688bebb04be12db707d1518fab8bdf594578b64fdea3056d1f0ed81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06cd54abd64cfb81ea5c48f91274535aa915cadce2dafedae7990a2e4f7dc767"
  end

  depends_on "rust" => :build

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    system "cargo", "install", *std_cargo_args
    bash_completion.install "lsd.bash"
    fish_completion.install "lsd.fish"
    zsh_completion.install "_lsd"
  end

  test do
    output = shell_output("#{bin}/lsd -l #{prefix}")
    assert_match "README.md", output
  end
end
