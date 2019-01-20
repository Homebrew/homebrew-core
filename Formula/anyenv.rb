class Anyenv < Formula
  desc "All in one for **env"
  homepage "https://anyenv.github.io/"
  url "https://github.com/anyenv/anyenv/archive/v0.1.2.tar.gz"
  sha256 "7c9b01926f246d07cd007b86d34b2abd6df357a8743733c8d55ab5a8bef46271"

  def install
    prefix.install %w[bin completions libexec]
  end

  def caveats
    <<~EOS
      Please add the line below to your profile of shell:

      eval "$(anyenv init -)"

      You can initialize install manifests directory by:

      anyenv install --init [git-url] [git-ref]
    EOS
  end

  test do
    shell_output("eval \"$(#{bin}/anyenv init -)\" && anyenv --version")
  end
end
