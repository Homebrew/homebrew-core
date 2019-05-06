class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/motemen/ghq"
  url "https://github.com/motemen/ghq/archive/v0.11.2.tar.gz"
  sha256 "4c06b2a5820d9add429186f5e06824d46e767b250c0ad4804e6889f34cf9e260"

  bottle do
    cellar :any_skip_relocation
    sha256 "5ab5ae494ac03905d01ff72c174ace9cf1f64904ff79f200837829235e89e047" => :mojave
    sha256 "115940b4fb322b72df6bbf0ca34aedd705cd4b8b70e51a0a1dc289439f3b07cb" => :high_sierra
    sha256 "56fb61c37a8708bedb53f81717ffc482ae0a755519c3ca608e9d56a2ecae8fa6" => :sierra
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
