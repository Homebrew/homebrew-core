class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/motemen/ghq"
  url "https://github.com/motemen/ghq/archive/v0.11.1.tar.gz"
  sha256 "e6b4c0bd757b4adde04b287e2e6816e90c1a0152923334f3d61a6619d333240d"

  bottle do
    cellar :any_skip_relocation
    sha256 "61927314ad3dbd9f7633d7c1d0182faa3b7c647d509ec203efb933fb6911062e" => :mojave
    sha256 "8190ca592f22a33fed6588426ad56b4a28ac8805a701348d76cc6afbb34d453b" => :high_sierra
    sha256 "9e289cb37606b8e1cc4ad017ea3f02642df4ea5debfd6ba7f1f0224386023f69" => :sierra
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
