class Pastel < Formula
  desc "Command-line tool to generate, analyze, convert and manipulate colors"
  homepage "https://github.com/sharkdp/pastel"
  url "https://github.com/sharkdp/pastel/archive/v0.7.1.tar.gz"
  sha256 "38ae098610aceb876fd29cfcd3b0bed6c9f1237a65e691ef7cbd670c27aa59b2"

  bottle do
    cellar :any_skip_relocation
    sha256 "a353ed8c114b5a65c2f82bd42d9e0a6e634a416ab852236999ade4e9ede86406" => :catalina
    sha256 "9e3c04c2ae69fb50826e45ae9249f983390dd8791833c074d6e50f10cd52b3e2" => :mojave
    sha256 "361a8200e697ca04c2e348264cda9dfd2caa4133c07a2c261e8ef68be472942d" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath/"completions"

    system "cargo", "install", "--locked", "--root", prefix, "--path", "."

    bash_completion.install "completions/pastel.bash"
    zsh_completion.install "completions/_pastel"
    fish_completion.install "completions/pastel.fish"
  end

  test do
    output = shell_output("#{bin}/pastel format hex rebeccapurple").strip

    assert_equal "#663399", output
  end
end
