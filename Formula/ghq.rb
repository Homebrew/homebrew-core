class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/motemen/ghq"
  url "https://github.com/motemen/ghq/archive/v0.12.1.tar.gz"
  sha256 "b1a8b25623bbdf1d295e1b76fd45508e23507c3e80162b577055c0c662451902"

  bottle do
    cellar :any_skip_relocation
    sha256 "551244fbe213ff88099a6dec95a0bc55fde2d3cf47131bba0622b989e00de730" => :mojave
    sha256 "29912d978485f5eb087848acf6230dfd99b88ae1faed4b83fdf675b2576d50b9" => :high_sierra
    sha256 "4145bcde01c3a71323ed9d78cad76f5f01e9ec6faedc06d40090f9bc8bc6883a" => :sierra
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "ghq"
    zsh_completion.install "zsh/_ghq"
  end

  test do
    assert_match "#{testpath}/.ghq", shell_output("#{bin}/ghq root")
  end
end
