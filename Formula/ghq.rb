class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/motemen/ghq"
  url "https://github.com/motemen/ghq.git",
      :tag      => "v0.14.2",
      :revision => "f56ab202a9775a8e469a1b4e158231f3e81d0e77"
  head "https://github.com/motemen/ghq.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9b959c9e1fea78ff40fa21a66169e9d76c115ed75795fe2d77b13201621d2fe9" => :catalina
    sha256 "488f8e55d37400c3ae960db893a0cf395645ff49fd2d065494c385e755303089" => :mojave
    sha256 "f83806bbb60ed01856bc0e080686ce25f8659d0efc7c96259ea210d0ba16df1d" => :high_sierra
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
