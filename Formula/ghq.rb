class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/motemen/ghq"
  url "https://github.com/motemen/ghq.git",
      :tag      => "v1.1.0",
      :revision => "057e0ffe6cc3ca0ea0ffdf3bdbb5f92e6fd780a4"
  head "https://github.com/motemen/ghq.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e933efa26b91c0d75d87c0c7f2d1872cf658823abe3714042cb4af71389295a1" => :catalina
    sha256 "c5aba963d67cc884f0f15d5095b4af803e967dbe37022c47cf53e4c896c486d3" => :mojave
    sha256 "8f429d8db1e7b14abaa12b8e24e12131be1883765fe06c8fcca5816fbc679168" => :high_sierra
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
