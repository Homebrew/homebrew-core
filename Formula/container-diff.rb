class ContainerDiff < Formula
  desc "Diff your Docker containers"
  homepage "https://github.com/GoogleCloudPlatform/container-diff"
  url "https://github.com/GoogleCloudPlatform/container-diff/archive/v0.6.2.tar.gz"
  sha256 "a3c680799c230d2a2352eb1e5765bd6774182b213a73e5c0bf1e6254008cd434"

  bottle do
    cellar :any_skip_relocation
    sha256 "4f6ecce8e1f3a8bf5e4423cc633e9167f7a79faf987932d3804004161c6dada4" => :high_sierra
    sha256 "12628b8737424bf66ed68b0e64d94487555a8470209222f3c04048ac8d762489" => :sierra
    sha256 "12505d31fe47ad0ce191f6625b44601810af9ef09b799720d42be12fd4a766a9" => :el_capitan
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
    image = "gcr.io/google-appengine/golang:2018-01-04_15_24"
    output = shell_output("#{bin}/container-diff analyze #{image} 2>&1")
    assert_match /-gcc-4.9-base\s+4.9.2-10/, output
  end
end
