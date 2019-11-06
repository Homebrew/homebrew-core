class Googler < Formula
  desc "Google Search and News from the command-line"
  homepage "https://github.com/jarun/googler"
  url "https://github.com/jarun/googler/archive/v3.9.tar.gz"
  sha256 "b90c6d28ad6ce0a2a2320806ab2133857fe1a0b6ca2a489d8eda1b8062e620e2"
  head "https://github.com/jarun/googler.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cf5c9f4171fc804dcb716731b0903f8abcd24c8e3f8cfe4f1a05e8fbf7f3bf69" => :catalina
    sha256 "724beb16d9338d490be09394270b39fd51a9923b4ba3e17720cfdbfeaf5f738e" => :mojave
    sha256 "724beb16d9338d490be09394270b39fd51a9923b4ba3e17720cfdbfeaf5f738e" => :high_sierra
    sha256 "154edd577647bfa1e4cdd9a314bc1dee531eb5772137641c7a6fcfec5cd441a8" => :sierra
  end

  depends_on "python"

  def install
    system "make", "disable-self-upgrade"
    system "make", "install", "PREFIX=#{prefix}"
    bash_completion.install "auto-completion/bash/googler-completion.bash"
    fish_completion.install "auto-completion/fish/googler.fish"
    zsh_completion.install "auto-completion/zsh/_googler"
  end

  test do
    ENV["PYTHONIOENCODING"] = "utf-8"
    assert_match "Homebrew", shell_output("#{bin}/googler --noprompt Homebrew")
  end
end
