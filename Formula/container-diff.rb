class ContainerDiff < Formula
  desc "Diff your Docker containers"
  homepage "https://github.com/GoogleContainerTools/container-diff"
  url "https://github.com/GoogleContainerTools/container-diff/archive/v0.12.0.tar.gz"
  sha256 "3f457c62073fac50493e7e237c247b30e1d1209ffb4c5b703def1a07a7822376"

  bottle do
    cellar :any_skip_relocation
    sha256 "54b10d99962c950d130460984ad07389d3bc0f11a1e8074e65314e14f4a8bf05" => :mojave
    sha256 "5d250647eb95b36d9ddc7f053f73ee311edee86656f6d79455358b120439d814" => :high_sierra
    sha256 "de5a08db0d135085f595fa4b7864d3844950c75e11f8d8a935b50a065af7a6d8" => :sierra
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
