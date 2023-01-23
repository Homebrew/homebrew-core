class Psysh < Formula
  desc "Runtime developer console, interactive debugger and REPL for PHP"
  homepage "https://psysh.org/"
  url "https://github.com/bobthecow/psysh/releases/download/v0.11.11/psysh-v0.11.11.tar.gz"
  sha256 "d7cd4ce0046b3fde5fc1824714333f269c5ab9661f0e9d38cb05029dc476d71f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2a5f8e552fe72f73c1c41a1295d0cfedcd1d30f72fb23540e5cc842bb9a308ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a5f8e552fe72f73c1c41a1295d0cfedcd1d30f72fb23540e5cc842bb9a308ed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2a5f8e552fe72f73c1c41a1295d0cfedcd1d30f72fb23540e5cc842bb9a308ed"
    sha256 cellar: :any_skip_relocation, ventura:        "41ea0c4af7051253d3e5ac93f047179dc1a2ff5bf14ac8a159970eae646c7061"
    sha256 cellar: :any_skip_relocation, monterey:       "41ea0c4af7051253d3e5ac93f047179dc1a2ff5bf14ac8a159970eae646c7061"
    sha256 cellar: :any_skip_relocation, big_sur:        "41ea0c4af7051253d3e5ac93f047179dc1a2ff5bf14ac8a159970eae646c7061"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a5f8e552fe72f73c1c41a1295d0cfedcd1d30f72fb23540e5cc842bb9a308ed"
  end

  depends_on "php"

  def install
    bin.install "psysh" => "psysh"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/psysh --version")

    (testpath/"src/hello.php").write <<~EOS
      <?php echo 'hello brew';
    EOS

    assert_match "hello brew", shell_output("#{bin}/psysh -n src/hello.php")
  end
end
