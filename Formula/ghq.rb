class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/motemen/ghq"
  url "https://github.com/motemen/ghq/archive/v0.10.2.tar.gz"
  sha256 "a19d60c4dbd7e56f171ff311a8934f9b0301ca25108061add26990e6b3d46025"

  bottle do
    cellar :any_skip_relocation
    sha256 "8b709d9cca1ca60f3354bd44d9b100661436645d85df4ae4fa712146a5be3ff9" => :mojave
    sha256 "88c26331cd1ba31fe82305fd0b0d74670056e42daf9df71f8523a3084d0f3d8b" => :high_sierra
    sha256 "111b812d26bc2aaf559b0cc21d56509912ab6c8f4db7cf1b9b442c9894b1b461" => :sierra
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "ghq"
    zsh_completion.install "zsh/_ghq"
  end

  test do
    assert_match "#{testpath}/.ghq", shell_output("#{bin}/ghq root")
  end
end
