class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/motemen/ghq"
  url "https://github.com/motemen/ghq.git",
      :tag      => "v0.99.1",
      :revision => "661921c8605c3e8d421d3149cd1d1a8a7ec226c8"
  head "https://github.com/motemen/ghq.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8b085e697ddf54d52c24b736b849b500128fab9bab4fb19bc437df4c93c3f250" => :catalina
    sha256 "378c51d604a745b0a6399e790b6fe54d7015adae5735793dc447d498fc28108b" => :mojave
    sha256 "4b218f4931ded4b6eda4a228d1d85aea90d79b824308183f2af745f08f7b741a" => :high_sierra
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
    assert_match "#{testpath}/ghq", shell_output("#{bin}/ghq root")
  end
end
