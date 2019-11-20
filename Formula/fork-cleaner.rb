class ForkCleaner < Formula
  desc "Cleans up old and inactive forks on your GitHub account"
  homepage "https://github.com/caarlos0/fork-cleaner"
  url "https://github.com/caarlos0/fork-cleaner/archive/v1.6.0.tar.gz"
  sha256 "14f34c9fbdfb868e7c33664e6a3997a53f9b4e3b1516a71cff8d27423f66ab6b"

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
