class ForkCleaner < Formula
  desc "Cleans up old and inactive forks on your GitHub account"
  homepage "https://github.com/caarlos0/fork-cleaner"
  url "https://github.com/caarlos0/fork-cleaner/archive/v1.3.0.tar.gz"
  sha256 "6cb97ed035cce26505f8d48406fb57029f629a6df19bfcfe44c8f3d7f60d1008"
  revision 1

  depends_on "go" => :build
  depends_on "dep" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/caarlos0/fork-cleaner").install buildpath.children
    cd "src/github.com/caarlos0/fork-cleaner" do
      system "dep", "ensure"
      system "make"
      bin.install "fork-cleaner"
      prefix.install_metafiles
    end
  end

  test do
    assert_match "missing github token",
      shell_output("#{bin}/fork-cleaner 2>&1", 1)
  end
end
