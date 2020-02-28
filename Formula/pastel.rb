class Pastel < Formula
  desc "Command-line tool to generate, analyze, convert and manipulate colors"
  homepage "https://github.com/sharkdp/pastel"
  url "https://github.com/sharkdp/pastel/archive/v0.7.0.tar.gz"
  sha256 "cd567b77087510e3ac4e3b5716905f5d01808adfbf8708e05dff83c39752271d"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "98a1ba143f1675f3c9a24ace7dc3047cd9b80c462b3b57a38448a81414d911a6" => :catalina
    sha256 "9ff2230b5d4405ca5d889aa6938ebc2d0189e3012fc6e367a6a4c5f4f28ecd3a" => :mojave
    sha256 "fa282f3adbef4bc3fe48690b0e539bf73b1abbf594c5ea93b9cc26cb25217c3b" => :high_sierra
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
