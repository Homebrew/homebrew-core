class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/motemen/ghq"
  url "https://github.com/motemen/ghq.git",
      :tag      => "v0.14.0",
      :revision => "ce6939542ed1176d3accc128fac17b3aebdc76e8"
  head "https://github.com/motemen/ghq.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4cd009f67833f8c8874335276d63fe52c130f9b63b73ec8b7521e67aa5ee5887" => :catalina
    sha256 "22134e924695b698b3d492b8994ad7a032d66f62f62ae607696308e74bcf4c4f" => :mojave
    sha256 "85d2cfd26987ebbd208edc9b33dbc4c965f2a40df8db827a7e7cb08632ceff12" => :high_sierra
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
