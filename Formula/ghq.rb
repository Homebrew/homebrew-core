class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/motemen/ghq"
  url "https://github.com/motemen/ghq.git",
      :tag      => "v0.12.5",
      :revision => "63a54af4381c6e7babbb2581a21e768cc4be59fa"

  bottle do
    cellar :any_skip_relocation
    sha256 "f6fe45358463d347e5580bda944983aef0faa4a858344d6a55784671a92a0f1f" => :mojave
    sha256 "a66918feb7ccfe57857504a648653c55d708d37ec4053fc313798ce578f6237b" => :high_sierra
    sha256 "2442362a2396aa941773f71a3ccca7560eb003f91217fc2960ec7c6f62f4284b" => :sierra
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
