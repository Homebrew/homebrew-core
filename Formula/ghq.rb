class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/x-motemen/ghq"
  url "https://github.com/x-motemen/ghq.git",
      tag:      "v1.2.1",
      revision: "dd139fb46cb7c1a3b19bca7a0c3762090c7c522f"
  license "MIT"
  head "https://github.com/x-motemen/ghq.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "252b76e8c00bafe3f020b3b25f789f61bed80896ec8f6d36ea7e88401b0c1551"
    sha256 cellar: :any_skip_relocation, big_sur:       "0754734268513b517299a2f8542db53b5773ba0ad316679c8b95544444181e25"
    sha256 cellar: :any_skip_relocation, catalina:      "00fb6673acdcdc32f9bfa9902379064428230d69b078e37774758e460bb569f3"
    sha256 cellar: :any_skip_relocation, mojave:        "057db5b6a8b7a18227bff7279e0719b2df4b55295fe8c415d3f697598afbd685"
  end

  depends_on "go" => :build

  def install
    system "make", "build", "VERBOSE=1"
    bin.install "ghq"
    bash_completion.install "misc/bash/_ghq" => "ghq"
    zsh_completion.install "misc/zsh/_ghq"
    prefix.install_metafiles
  end

  test do
    assert_match "#{testpath}/ghq", shell_output("#{bin}/ghq root")
  end
end
