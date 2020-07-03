class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/x-motemen/ghq"
  url "https://github.com/x-motemen/ghq.git",
      :tag      => "v1.1.4",
      :revision => "5b8d4e4ca8099e8de0188d6174eb58217e05d503"
  head "https://github.com/x-motemen/ghq.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8b50baf86d4bab90bf650a450fbbb3dc4e5f3132fe47207d68bf6681bee57f26" => :catalina
    sha256 "517f67f0c52fec93f32c7d327baaf2062e8c16ca644560710c59a88f415d174f" => :mojave
    sha256 "b908d0c46b72a968487f3a4d68e3397314d9277b09f89bab9c8c1af412703816" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make", "build", "VERBOSE=1"
    bin.install "ghq"
    bash_completion.install "misc/bash/_ghq" => "ghq"
    zsh_completion.install "misc/zsh/_ghq"
    prefix.install_metafiles
  end

  test do
    assert_match "#{testpath}/ghq", shell_output("#{bin}/ghq root")
  end
end
