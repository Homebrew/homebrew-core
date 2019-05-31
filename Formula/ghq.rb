class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/motemen/ghq"
  url "https://github.com/motemen/ghq.git",
      :tag      => "v0.12.6",
      :revision => "f75cda17931f3d24829f425344dff18f91d78bf6"

  bottle do
    cellar :any_skip_relocation
    sha256 "8ca99b5fbf5355476eb5a5917e6b9e37c1ed29eff9624b25b848e9b6b5085d20" => :mojave
    sha256 "bd86d29eefe0cc7899676898d54ddbb58f634468cc8f2a9d148b28da9e8ad640" => :high_sierra
    sha256 "03e8f1cc099f99745fbcbf91941aad0db08086ed50ac62288dc9068cffd373eb" => :sierra
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "ghq"
    zsh_completion.install "zsh/_ghq"
    prefix.install_metafiles
  end

  test do
    assert_match "#{testpath}/.ghq", shell_output("#{bin}/ghq root")
  end
end
