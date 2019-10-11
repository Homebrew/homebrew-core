class Pastel < Formula
  desc "Command-line tool to generate, analyze, convert and manipulate colors"
  homepage "https://github.com/sharkdp/pastel"
  url "https://github.com/sharkdp/pastel/archive/v0.6.1.tar.gz"
  sha256 "ece0004d725133bcf552bbfe5508c087513eb52f6c363fbad6eeb9c74769a932"

  bottle do
    cellar :any_skip_relocation
    sha256 "bd8d2f6e7c1543e6125f903b5c1d679ad285798bff61f878aa8adbd215c3fe38" => :catalina
    sha256 "833c6fd6d2448758422a7f767089ea9e8880051c77ddf7be0579f7d31938c429" => :mojave
    sha256 "eb942a372e4b0eb8e707c2c4a68cae26e1664c551107046d9ff7b9de1570ed5c" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath/"completions"

    system "cargo", "install", "--root", prefix, "--path", "."

    bash_completion.install "completions/pastel.bash"
    zsh_completion.install "completions/_pastel"
    fish_completion.install "completions/pastel.fish"
  end

  test do
    output = shell_output("#{bin}/pastel format hex rebeccapurple").strip

    assert_equal "#663399", output
  end
end
