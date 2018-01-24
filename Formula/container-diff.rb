class ContainerDiff < Formula
  desc "Diff your Docker containers"
  homepage "https://github.com/GoogleCloudPlatform/container-diff"
  url "https://github.com/GoogleCloudPlatform/container-diff/archive/v0.6.2.tar.gz"
  sha256 "a3c680799c230d2a2352eb1e5765bd6774182b213a73e5c0bf1e6254008cd434"

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
    image = "gcr.io/google-appengine/golang:2018-01-04_15_24"
    output = shell_output("#{bin}/container-diff analyze #{image} 2>&1")
    assert_match /-gcc-4.9-base\s+4.9.2-10/, output
  end
end
