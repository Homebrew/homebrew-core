class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/motemen/ghq"
  url "https://github.com/motemen/ghq.git",
      :tag      => "v1.0.0",
      :revision => "dd6ffec5a854ddee737f454a1ace636edc70a4a4"
  head "https://github.com/motemen/ghq.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "921b162ef687f7fb5ad1f02aefcdb29b0816a667ffc95b59e7a867b68a1bac68" => :catalina
    sha256 "86e0ee50ecec8d9782d5ad03802e3fd4b3eb3f43120320b57073476feec0dcdd" => :mojave
    sha256 "988c29516bf099a934a8a03c74affbe4ce3f7c3dda936a01ddb977f99b8b5136" => :high_sierra
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
