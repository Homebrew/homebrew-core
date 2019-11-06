class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/motemen/ghq"
  url "https://github.com/motemen/ghq.git",
      :tag      => "v0.12.8",
      :revision => "fe5ca0511e4d028be926215d05590638e3995c99"
  head "https://github.com/motemen/ghq.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c17b2fd413cb7a1a2c681e863fc3ea5ff14b3910bf77b37464812fca3b0875b5" => :catalina
    sha256 "9e421aaaf0c7b2340c7367d70144a7f1b8a99f37f3165abcd8527afd6e1989a1" => :mojave
    sha256 "441bec0507a8ec029a4afa8832e7d64a26775d50859226859b1098f912f32918" => :high_sierra
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
