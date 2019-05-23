class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/motemen/ghq"
  url "https://github.com/motemen/ghq/archive/v0.12.3.tar.gz"
  sha256 "5bf67452b75d31feb9e4cac3fe414a3ed9c4c0e05bb1f66785feb4980452132b"

  bottle do
    cellar :any_skip_relocation
    sha256 "8714e04e8f2253aecbc7951170bf634c90bd5d0f2db8a7ed13440d3ec0633ca1" => :mojave
    sha256 "e3b8223fca55e281d5c40de5c2710b132b06ad062300c4bf5415f7c779d4a22c" => :high_sierra
    sha256 "5ea0025b612426579195cacded202a6595cf8345185aba357592af4b06097ad8" => :sierra
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
