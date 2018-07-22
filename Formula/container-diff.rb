class ContainerDiff < Formula
  desc "Diff your Docker containers"
  homepage "https://github.com/GoogleContainerTools/container-diff"
  url "https://github.com/GoogleContainerTools/container-diff/archive/v0.11.0.tar.gz"
  sha256 "b86361c6cd091c0d25809743f7ca883b856438a20b9e100c1925638c8296698d"

  bottle do
    cellar :any_skip_relocation
    sha256 "c47685c267cbe10f383dd09f7b0435d54a84684ef52ef81c4f917a32ca4656bc" => :high_sierra
    sha256 "97e074a8be3cf34f6bf4271fe16817701096df34e2a541d47758edb5e5ee788e" => :sierra
    sha256 "fe16c0f1a6f78a2488782d09321d1b70765c6192bf56afd483f0f22c47845b5a" => :el_capitan
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
