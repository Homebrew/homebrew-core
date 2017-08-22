class Anyenv < Formula
  desc "Simple wrapper for rbenv style environment managers"
  homepage "https://github.com/riywo/anyenv#readme"
  url "https://github.com/riywo/anyenv/archive/master.zip"
  version "3cb8ad1b0dfd89ed5a53fcc9e076b371f6baabfc"
  sha256 "93ba15828fdb2fc88371eb4afa5bbe953e0a172dd8ef280f8c4e7d74e497cfcf"
  head "https://github.com/riywo/anyenv.git"

  option "without-completions", "Disable bash/fish/zsh completions"

  def install
    inreplace "libexec/anyenv", "ANYENV_ROOT=\"${HOME}/.anyenv\"", "ANYENV_ROOT=\"#{prefix}\""
    prefix.install Dir["*"]

    if build.with? "completions"
      bash_completion.install prefix/"completions/anyenv.bash"
      fish_completion.install prefix/"completions/anyenv.fish"
      zsh_completion.install prefix/"completions/anyenv.zsh" => "_anyenv"
    end
  end

  def caveats; <<-EOS.undent
    Add the following to the ~/.bashrc or ~/.zshrc file:
      echo 'eval "$(anyenv init -)"' >> ~/.your_profile
    EOS
  end

  test do
    shell_output("eval \"$(#{bin}/anyanv init -)\" && anyenv versions")
  end
end
