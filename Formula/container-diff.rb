class ContainerDiff < Formula
  desc "Diff your Docker containers"
  homepage "https://github.com/GoogleCloudPlatform/container-diff"
  url "https://github.com/GoogleCloudPlatform/container-diff/archive/v0.9.0.tar.gz"
  sha256 "cf5957fd9c583030283982dafab0b70608c739408d036444d9acc0a867e7472f"

  bottle do
    cellar :any_skip_relocation
    sha256 "b02b2c908f3fc6682c792b24f8b9e42c8049c0d1d7cef3a99852156048ccf2db" => :high_sierra
    sha256 "1e11353fdbfbe3ef68bc79a06f90d2f575d140c5d451b88330c5fb319f326dff" => :sierra
    sha256 "535a6527f264e9c02435fcd549052e40d605645afb17bafd6efbd117fbdad053" => :el_capitan
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
