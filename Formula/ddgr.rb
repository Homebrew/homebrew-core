class Ddgr < Formula
  desc "DuckDuckGo from the terminal"
  homepage "https://github.com/jarun/ddgr"
  url "https://github.com/jarun/ddgr/archive/v1.6.tar.gz"
  sha256 "eae7ff1ab44dfda168a8bbe46593e80ca4a26ab45a9efbab13e6f466349e0e5c"

  bottle do
    cellar :any_skip_relocation
    sha256 "0c307cf8cb01fee1ad0306e8463dfae4ece2d47974e3d44105326255b0b72a03" => :mojave
    sha256 "598196edcbeb1d40d9288bad01775b2b56713758e24a51538a6487dc57bd8521" => :high_sierra
    sha256 "598196edcbeb1d40d9288bad01775b2b56713758e24a51538a6487dc57bd8521" => :sierra
  end

  depends_on "python"

  def install
    system "make", "install", "PREFIX=#{prefix}"
    bash_completion.install "auto-completion/bash/ddgr-completion.bash"
    fish_completion.install "auto-completion/fish/ddgr.fish"
    zsh_completion.install "auto-completion/zsh/_ddgr"
  end

  test do
    ENV["PYTHONIOENCODING"] = "utf-8"
    assert_match "Homebrew", shell_output("#{bin}/ddgr --noprompt Homebrew")
  end
end
