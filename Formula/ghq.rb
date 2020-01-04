class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/motemen/ghq"
  url "https://github.com/motemen/ghq.git",
      :tag      => "v0.99.2",
      :revision => "69aea14edeb7b7b213528445c9dc8c0e082bb171"
  head "https://github.com/motemen/ghq.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f3adbb41ce222dc0ab1e23ea4c7b59d4d30d1b5dc01b57015268b73640902db3" => :catalina
    sha256 "eb86f7174cc74031947befdd57d29146a902825fefba69f4a32260a02efc0039" => :mojave
    sha256 "792c8b7a1be6948b9dcf08a01a152ba4492511b1a95ae2a268f6bc92cdaf60fd" => :high_sierra
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
