class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/x-motemen/ghq"
  url "https://github.com/x-motemen/ghq.git",
      :tag      => "v1.1.0",
      :revision => "057e0ffe6cc3ca0ea0ffdf3bdbb5f92e6fd780a4"
  head "https://github.com/x-motemen/ghq.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "094a5d328a580acd73d1d7759a45170648a03870521e229f36e01c3ce3f0fae8" => :catalina
    sha256 "8a92b1559028e62b2adf94031343effb73fc1adf796e117323c2be8942c4c626" => :mojave
    sha256 "a329280f22f251831749b1cb38c8eff4645fa2bbf81e2488254981736593bb16" => :high_sierra
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
