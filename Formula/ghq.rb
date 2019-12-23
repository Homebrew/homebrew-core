class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/motemen/ghq"
  url "https://github.com/motemen/ghq.git",
      :tag      => "v0.15.0",
      :revision => "1cfb0dca91a4f78e3472892ae0d9cab94be6fd86"
  head "https://github.com/motemen/ghq.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a04277cb220930791a67f14217477d7e7cce730df2649247f64830777063f02f" => :catalina
    sha256 "8c96a802da841a7f86a849d70de53f727702a3f5233b73fef4c45c6ec0a9d141" => :mojave
    sha256 "8ae0017f9ba9da87ddbf925b7fcdc8c2bbfe670717e1a437271afd28694c9920" => :high_sierra
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
