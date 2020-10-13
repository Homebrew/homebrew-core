class Googler < Formula
  include Language::Python::Shebang

  desc "Google Search and News from the command-line"
  homepage "https://github.com/jarun/googler"
  url "https://github.com/jarun/googler/archive/v4.3.1.tar.gz"
  sha256 "f756182ed383050cbdaac8ee4f02c904ca26f76a727f3ec58cc8ab6a8cba3f23"
  license "GPL-3.0"
  head "https://github.com/jarun/googler.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c4fb5962e04ee3941d712fd0c94019c55e9ee06ee022ab48258a728d3175ded4" => :catalina
    sha256 "353a9c1e807a98e75b12c216f896a4204c032f34485522561c73b918445fb482" => :mojave
    sha256 "2eacfab54e0ff38c0befb5d72cc6040c291eba6dfebf505f274c44ec7bfaf98b" => :high_sierra
  end

  depends_on "python@3.9"

  def install
    rewrite_shebang detected_python_shebang, "googler"
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
