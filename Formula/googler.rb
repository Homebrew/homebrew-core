class Googler < Formula
  include Language::Python::Shebang

  desc "Google Search and News from the command-line"
  homepage "https://github.com/jarun/googler"
  url "https://github.com/jarun/googler/archive/v4.2.tar.gz"
  sha256 "ee0887ec30aea14823bb32117c97f4af8cdba381244b393665d2e273f8b60b43"
  license "GPL-3.0"
  head "https://github.com/jarun/googler.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f61c5b26c1384e2f7a8e41245b2d9e6c0e006c8dc5f507c2153410ee4a72f7a3" => :catalina
    sha256 "f61c5b26c1384e2f7a8e41245b2d9e6c0e006c8dc5f507c2153410ee4a72f7a3" => :mojave
    sha256 "f61c5b26c1384e2f7a8e41245b2d9e6c0e006c8dc5f507c2153410ee4a72f7a3" => :high_sierra
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
