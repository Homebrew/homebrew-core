class ForkCleaner < Formula
  desc "Cleans up old and inactive forks on your GitHub account"
  homepage "https://github.com/caarlos0/fork-cleaner"
  url "https://github.com/caarlos0/fork-cleaner/archive/v1.5.1.tar.gz"
  sha256 "b3a52059683b3151717a51d2496327e4b2d16a8462e8762a7135d54fa2dd2a10"

  bottle do
    cellar :any_skip_relocation
    sha256 "637e916a5d2bd256c44009e07d0fc601ab3387cf1b5a32647d400f4ddb2847dc" => :catalina
    sha256 "48f04ccbdc0a49dde4eec4047cb0a7fa3ce3cce13941aea24dea0b9927360b03" => :mojave
    sha256 "f94255813bbfd61438e9d424042e78dcda03ab165ac85af14da8f2810ca1cf7d" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/caarlos0/fork-cleaner"
    dir.install buildpath.children

    cd dir do
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
