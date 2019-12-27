class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/motemen/ghq"
  url "https://github.com/motemen/ghq.git",
      :tag      => "v0.17.1",
      :revision => "5add27b66cbb918e28f195a9065f6875b1a33392"
  revision 1
  head "https://github.com/motemen/ghq.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "214748695423c028f53102f22efa2513800a3ccf09342c028cdeb59f972ef42a" => :catalina
    sha256 "2ca84c842ddbd3ea399aa62e3f5ed86359e60b09b7edd1b3a8aa1a63ce813908" => :mojave
    sha256 "9510f724a856e2c1c7579e1d252af30b013625dcf936e604c4322257f14594ab" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "ghq"
    bash_completion.install "misc/bash/_ghq" => "ghq"
    zsh_completion.install "misc/zsh/_ghq"
    prefix.install_metafiles
  end

  test do
    assert_match "#{testpath}/.ghq", shell_output("#{bin}/ghq root")
  end
end
