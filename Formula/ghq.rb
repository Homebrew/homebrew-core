class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https://github.com/motemen/ghq"
  url "https://github.com/motemen/ghq/archive/v0.11.2.tar.gz"
  sha256 "4c06b2a5820d9add429186f5e06824d46e767b250c0ad4804e6889f34cf9e260"

  bottle do
    cellar :any_skip_relocation
    sha256 "b6030ef360ba8edc6309760a483ff71f0fc7bdf9e6e5cc88f9a9d79417d74f48" => :mojave
    sha256 "dec2c61587341a5d361b26e43bfb97ab7d7369c1debba7043a521dd1c8ba3533" => :high_sierra
    sha256 "7d4318973530bbc523e45f9ab5371d34482959205379d85a7b8f184d6199f6c1" => :sierra
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
