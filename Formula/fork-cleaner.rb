class ForkCleaner < Formula
  desc "Cleans up old and inactive forks on your GitHub account"
  homepage "https://github.com/caarlos0/fork-cleaner"
  url "https://github.com/caarlos0/fork-cleaner/archive/v1.3.1.tar.gz"
  sha256 "d3259e74eb12f588fbd3073a27ba6efd4d36e467e84d346a466815fa8a4920ae"

  bottle do
    cellar :any_skip_relocation
    sha256 "a032b6000f0bd39df01d27c2d29e40d3c5cc3fbd96038b4ee725520ed480caf1" => :high_sierra
    sha256 "087b9587f8e3ee97870e7d39a83f911d9f722ef635827d4f6e702da24dfd2f97" => :sierra
    sha256 "722ca44ef67666816c902ee980fa0838879e60dfe00f0ca4fd4fbf626948b462" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/caarlos0/fork-cleaner"
    dir.install buildpath.children
    cd dir do
      system "dep", "ensure"
      system "make"
      bin.install "fork-cleaner"
      prefix.install_metafiles
    end
  end

  test do
    output = shell_output("#{bin}/fork-cleaner 2>&1", 1)
    assert_match "missing github token", output
  end
end
