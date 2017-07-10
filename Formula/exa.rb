class Exa < Formula
  desc "Modern replacement for 'ls'"
  homepage "https://the.exa.website"
  url "https://github.com/ogham/exa/archive/v0.7.0.tar.gz"
  sha256 "1be554f28a234741cdc336891996969c49c16c80c8ca84dedb05e76b4ccac709"
  head "https://github.com/ogham/exa.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "96577212829215a642d989b6de615bdf36d4b7170fa8d4e2e8cafb259b442f99" => :sierra
    sha256 "b356d32e38e2b7d0ca3b9874ab33a9aead45d1c46d8fa84e1b4819f0c7a78632" => :el_capitan
    sha256 "5693b6852ccdf92ec6b71dd671be1980aeefea0c0e86aaf9e3d86058afe42b52" => :yosemite
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
