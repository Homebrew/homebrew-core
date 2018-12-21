class ContainerDiff < Formula
  desc "Diff your Docker containers"
  homepage "https://github.com/GoogleContainerTools/container-diff"
  url "https://github.com/GoogleContainerTools/container-diff/archive/v0.14.0.tar.gz"
  sha256 "5dbafdc38524dad60286da2d7a7d303285de2e08e070ce3dcc1488dbfecd116b"

  bottle do
    cellar :any_skip_relocation
    sha256 "08c168cd3c1886e1a97238bb71ed345d2bfaebcabf53bb09f0ca31c8f3282919" => :mojave
    sha256 "ee1bcd0d01a88f6858a5792b5bd335d381c0102edae28ffc6ca2f7829a73b702" => :high_sierra
    sha256 "34b9450a1cf011216a2b308087b5648cbeca33781947f2046270810c2cf950cb" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/GoogleContainerTools").mkpath
    ln_sf buildpath, buildpath/"src/github.com/GoogleContainerTools/container-diff"

    cd "src/github.com/GoogleContainerTools/container-diff" do
      system "make"
      bin.install "out/container-diff"
    end
  end

  test do
    image = "daemon://gcr.io/google-appengine/golang:2018-01-04_15_24"
    output = shell_output("#{bin}/container-diff analyze #{image} 2>&1", 1)
    assert_match "Cannot connect to the Docker daemon", output
  end
end
