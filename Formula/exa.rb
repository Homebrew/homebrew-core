class Exa < Formula
  desc "Modern replacement for 'ls'"
  homepage "https://the.exa.website"
  url "https://github.com/ogham/exa/archive/v0.7.0.tar.gz"
  sha256 "1be554f28a234741cdc336891996969c49c16c80c8ca84dedb05e76b4ccac709"
  head "https://github.com/ogham/exa.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "51387bb2d0a5b6a6087e8e826f1ffd72852152a0d392afea650368d7b2cf78b1" => :sierra
    sha256 "87144c3eaf9c2d1a78d27f926af4826ab6470e9331dbe8fdf84af5c34cad0658" => :el_capitan
    sha256 "22538ceddc613b45dbbc80a85ad0ea0f397c755c53fe58df605105bf1f411653" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

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
