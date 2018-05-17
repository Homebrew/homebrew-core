class ForkCleaner < Formula
  desc "Cleans up old and inactive forks on your GitHub account"
  homepage "https://github.com/caarlos0/fork-cleaner"
  url "https://github.com/caarlos0/fork-cleaner/archive/v1.3.1.tar.gz"
  sha256 "d3259e74eb12f588fbd3073a27ba6efd4d36e467e84d346a466815fa8a4920ae"

  bottle do
    cellar :any_skip_relocation
    sha256 "54b01c44edf23b6d8d6909d7b2cb594f8bd2df01993d41a837b43d3ceb3f07ef" => :high_sierra
    sha256 "44c2eefd8d2e85b53af2b4414d5fd8387128e0b59e1bd47a076340378d755eb4" => :sierra
    sha256 "2c5420d0c8866a7dd1836dbf569f6dff1b136c8dbae7266bc2ea340aea8c06c1" => :el_capitan
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
