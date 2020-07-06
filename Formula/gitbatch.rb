class Gitbatch < Formula
  desc "Manage your git repositories in one place"
  homepage "https://github.com/isacikgoz/gitbatch"
  url "https://github.com/isacikgoz/gitbatch/archive/v0.5.0.tar.gz"
  sha256 "b1781bb1a0f16545d8980d4f854cb4685c289b222d141197889fc387524aa515"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "58b204bd1779e99cade465f98457ec14cadaee9a3b65afe099245faba640da0c" => :catalina
    sha256 "31d8b72293ceacef7d44beb203887ff80628cb5cd3b56a9f0b467704d153b261" => :mojave
    sha256 "73fc219e77776b78635c672111736a1ce26f6f1afe0df4ce7c571341578cd1e9" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/name
  end

  test do
    mkdir testpath/"repo" do
      system "git", "init"
    end
    assert_match "1 repositories finished", shell_output("#{bin}/gitbatch -q")
  end
end
