class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/x-motemen/ghq"
  url "https://github.com/x-motemen/ghq.git",
      :tag      => "v1.1.3",
      :revision => "c122cb9ee09dcc49cb78690a8426d4cf177e3255"
  head "https://github.com/x-motemen/ghq.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d0bd2350b28198b13af3660f1bcd90fe711978abc5e1134b8f9b20f3d15db97f" => :catalina
    sha256 "234a56c6c0ec53ce736a0c492ee552c9ce15e865772067ff19974a6163480bdc" => :mojave
    sha256 "c17f57d9a87ffecf38dcbb7d95d8f9f72657d79a96e305f38d9e1cbee30aba7d" => :high_sierra
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
