class ContainerDiff < Formula
  desc "Diff your Docker containers"
  homepage "https://github.com/GoogleCloudPlatform/container-diff"
  url "https://github.com/GoogleCloudPlatform/container-diff/archive/v0.8.0.tar.gz"
  sha256 "e6a9bf2c30babd16bc7efe5803d9a2cbdd733206d4b1bc71fe7a442872848623"

  bottle do
    cellar :any_skip_relocation
    sha256 "c5479aa521704785c182b2bdb3958a2f0d32c8cbfc4de2780047d1036f2da296" => :high_sierra
    sha256 "fe5425a9c250f622b84c14154c4c6f839cf1abd46b3d42826363e2147fe5f523" => :sierra
    sha256 "eb5d282662e35501bbb48de19f592f111927a2e5d1f2f0474096e758156bd6d1" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/GoogleCloudPlatform").mkpath
    ln_sf buildpath, buildpath/"src/github.com/GoogleCloudPlatform/container-diff"

    cd "src/github.com/GoogleCloudPlatform/container-diff" do
      system "make"
      bin.install "out/container-diff"
    end
  end

  test do
    image = "daemon://gcr.io/google-appengine/golang:2018-01-04_15_24"
    output = shell_output("#{bin}/container-diff analyze #{image} 2>&1", 1)
    assert_match "Error loading image from docker engine", output
  end
end
