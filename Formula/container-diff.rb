class ContainerDiff < Formula
  desc "Diff your Docker containers"
  homepage "https://github.com/GoogleContainerTools/container-diff"
  url "https://github.com/GoogleContainerTools/container-diff/archive/v0.10.0.tar.gz"
  sha256 "55b62ee0081b9ef5bf5778a6ea30b61f2ee6ee16bfaa7b26bae793455486cc2c"

  bottle do
    cellar :any_skip_relocation
    sha256 "b02b2c908f3fc6682c792b24f8b9e42c8049c0d1d7cef3a99852156048ccf2db" => :high_sierra
    sha256 "1e11353fdbfbe3ef68bc79a06f90d2f575d140c5d451b88330c5fb319f326dff" => :sierra
    sha256 "535a6527f264e9c02435fcd549052e40d605645afb17bafd6efbd117fbdad053" => :el_capitan
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
