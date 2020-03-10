class Pastel < Formula
  desc "Command-line tool to generate, analyze, convert and manipulate colors"
  homepage "https://github.com/sharkdp/pastel"
  url "https://github.com/sharkdp/pastel/archive/v0.7.1.tar.gz"
  sha256 "38ae098610aceb876fd29cfcd3b0bed6c9f1237a65e691ef7cbd670c27aa59b2"

  bottle do
    cellar :any_skip_relocation
    sha256 "ec760b913a8be2ef4cd8c69bb37446d0750717ee2d193835a1f09134b1631bc7" => :catalina
    sha256 "265317c1a66f0db619512ed8c660a465a85b65662c421e37b0d940dc43cecb67" => :mojave
    sha256 "4310d41ed69f7be84fd11cd5fba26c17db4f1140fdb9ffa91278d44c05982cae" => :high_sierra
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
