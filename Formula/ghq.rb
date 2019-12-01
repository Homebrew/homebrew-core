class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/motemen/ghq"
  url "https://github.com/motemen/ghq.git",
      :tag      => "v0.13.0",
      :revision => "7ba9b5f82952dc930f289262a2df7bafb6bd53bf"
  head "https://github.com/motemen/ghq.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c1049d2ebbe1deb69cdb58f7e3ea7d63a36f6128135962cd1da63aadf7d68db7" => :catalina
    sha256 "78d83748b4a7d89ea17fba47f29d36e554c8efe4b5b85a0f64c90cb2bc1b8fc9" => :mojave
    sha256 "30c1b6f14b0969a75de43ef6679df89247e8742029028fdb8cc24da1977b553a" => :high_sierra
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
