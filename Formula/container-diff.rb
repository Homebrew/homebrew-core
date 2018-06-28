class ContainerDiff < Formula
  desc "Diff your Docker containers"
  homepage "https://github.com/GoogleContainerTools/container-diff"
  url "https://github.com/GoogleContainerTools/container-diff/archive/v0.11.0.tar.gz"
  sha256 "b86361c6cd091c0d25809743f7ca883b856438a20b9e100c1925638c8296698d"

  bottle do
    cellar :any_skip_relocation
    sha256 "755d9916daee6ca4896632b469c81ec81a5499442170832b27be48e9e5827512" => :high_sierra
    sha256 "8ca23f36cae8664496b98ae89b76f02a30845a524712a5f4ec0781571a803b84" => :sierra
    sha256 "f18a40fbbe48824f1316343fc0a00372ba002a20ca4ffa68f0b0e7264d23ce70" => :el_capitan
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
