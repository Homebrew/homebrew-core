class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/motemen/ghq"
  url "https://github.com/motemen/ghq/archive/v0.12.2.tar.gz"
  sha256 "0bbf43cb46ed23e0fa1b8d68ff7fdc7f2646f055220bf61fc9530bef4e020eb8"

  bottle do
    cellar :any_skip_relocation
    sha256 "6fe66a187b32c6e01cb979745199517bb5ac11091030b7b6ca3277a3db9b286d" => :mojave
    sha256 "522c77eb1c3da16ce3495aba58ae10d36e0fc949e88cc89b7fd4945721de7795" => :high_sierra
    sha256 "9cdb2082a1b292f4e69c0925a5ebc1b8eccbd134f0d83e04fde250214ba49ba0" => :sierra
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
