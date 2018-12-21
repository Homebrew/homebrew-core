class ContainerDiff < Formula
  desc "Diff your Docker containers"
  homepage "https://github.com/GoogleContainerTools/container-diff"
  url "https://github.com/GoogleContainerTools/container-diff/archive/v0.14.0.tar.gz"
  sha256 "5dbafdc38524dad60286da2d7a7d303285de2e08e070ce3dcc1488dbfecd116b"

  bottle do
    cellar :any_skip_relocation
    sha256 "4c7301a6c6aa751b405e6d5fef11110c5da97a5a079ff5df2ef8795ff0ef076f" => :mojave
    sha256 "53b5753eb3d8d91e32866127892f94115f240f89da26e0a4bc21f1773821a3c7" => :high_sierra
    sha256 "a28035baa77f2df37002a905d01acc381b83c1a379086bc520ba1357db96717b" => :sierra
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
