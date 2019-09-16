class Pastel < Formula
  desc "Command-line tool to generate, analyze, convert and manipulate colors"
  homepage "https://github.com/sharkdp/pastel"
  url "https://github.com/sharkdp/pastel/archive/v0.5.3.tar.gz"
  sha256 "0850e37b92b8d2f5a396d5b9114a21a64dce5c6cce736039151c800f35abaa1e"

  bottle do
    cellar :any_skip_relocation
    sha256 "cd35a70df7798441446d2494d45be08844bfc261d3235d8b9a4da976d372fd1b" => :mojave
    sha256 "6c22ebd7ef0c661c1c616ed366cf128983ade51947248116ef18ba0a7a58f586" => :high_sierra
    sha256 "8f63ddedd1873d13bf383e9e574c18ebaa0a29e6f4adfa75ea2ed7a2b23bdada" => :sierra
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
