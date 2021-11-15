class Googler < Formula
  include Language::Python::Shebang

  desc "Google Search and News from the command-line"
  homepage "https://github.com/jarun/googler"
  url "https://github.com/jarun/googler/archive/v4.3.2.tar.gz"
  sha256 "bd59af407e9a45c8a6fcbeb720790cb9eccff21dc7e184716a60e29f14c68d54"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/jarun/googler.git"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "18cddbd924b8544fa84dce44221443c08053e1939f4b638538e0da04a696df03"
  end

  depends_on "python@3.10"

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
