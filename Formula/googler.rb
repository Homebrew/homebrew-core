class Googler < Formula
  include Language::Python::Shebang

  desc "Google Search and News from the command-line"
  homepage "https://github.com/jarun/googler"
  url "https://github.com/jarun/googler/archive/v4.0.tar.gz"
  sha256 "f72593ca2a3dccd7301c0fed55effd223cc38f6c21910bffbbfba1360c985cd3"
  revision 1
  head "https://github.com/jarun/googler.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1ee5b39a9a4e7bbdb32c85e59303b8d77e31b2e75acb218151d48fb2a7fd5fac" => :catalina
    sha256 "1ee5b39a9a4e7bbdb32c85e59303b8d77e31b2e75acb218151d48fb2a7fd5fac" => :mojave
    sha256 "1ee5b39a9a4e7bbdb32c85e59303b8d77e31b2e75acb218151d48fb2a7fd5fac" => :high_sierra
  end

  depends_on "python@3.8"

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
