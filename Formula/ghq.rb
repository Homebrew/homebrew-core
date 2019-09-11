class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/motemen/ghq"
  url "https://github.com/motemen/ghq.git",
      :tag      => "v0.12.6",
      :revision => "f75cda17931f3d24829f425344dff18f91d78bf6"

  bottle do
    cellar :any_skip_relocation
    sha256 "feb197303052612409d47fdfcaa1ed48e617a2a6c561d24a9590994ba8f956f5" => :mojave
    sha256 "5b301b1b73f6e915107fad6dbe50de2f298cfdc0e847f926bd64205935c3922d" => :high_sierra
    sha256 "4d36b962ed79ab2736ecd7bd8b7480ac00a13258df8ad2f0c37226abcb660b4d" => :sierra
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
