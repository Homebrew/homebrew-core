class Exa < Formula
  desc "Modern replacement for 'ls'"
  homepage "https://the.exa.website"
  url "https://github.com/ogham/exa/archive/v0.9.0.tar.gz"
  sha256 "96e743ffac0512a278de9ca3277183536ee8b691a46ff200ec27e28108fef783"
  head "https://github.com/ogham/exa.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cc484e7deb12cdae4ede810258be0ca069d7db395897e9d3fbadd501fb075743" => :catalina
    sha256 "bc80009ad845d914c08e6de1c39c97e0f4f180ef4f077b3ef1957cab519d6743" => :mojave
    sha256 "7382b758899c756f94c4c99440f71075945d333e302e53139e423fb1798c852e" => :high_sierra
    sha256 "9499359da5f5fffbd8b22c8cb8e78f0fdf99594c4d2b06e7ba58eb21afbcb582" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "make", "install", "PREFIX=#{prefix}"

    bash_completion.install "contrib/completions.bash" => "exa"
    zsh_completion.install  "contrib/completions.zsh"  => "_exa"
    fish_completion.install "contrib/completions.fish" => "exa.fish"
  end

  test do
    (testpath/"test.txt").write("")
    assert_match "test.txt", shell_output("#{bin}/exa")
  end
end
