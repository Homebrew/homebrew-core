class ForkCleaner < Formula
  desc "Cleans up old and inactive forks on your GitHub account"
  homepage "https://github.com/caarlos0/fork-cleaner"
  url "https://github.com/caarlos0/fork-cleaner/archive/v1.4.3.tar.gz"
  sha256 "5a71b3d454ac030522ea5fd8f78b90432d4a9a299c2b923388e7f9ee223795d8"

  bottle do
    cellar :any_skip_relocation
    sha256 "ba35506a75b9214f547ab1247e00a1774da42b7b6caf5ad7838786a4311d82aa" => :mojave
    sha256 "1186f25c26a39b69cc5a45a48b60f8f663dbd7ac450fd7b69b20941d798cb11b" => :high_sierra
    sha256 "c4f6ff2fb271638993210665fa49a44a6bb57f40116f87e7f1872029dc10000f" => :sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/caarlos0/fork-cleaner"
    dir.install buildpath.children
    cd dir do
      system "dep", "ensure", "-vendor-only"
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
