class ContainerDiff < Formula
  desc "Diff your Docker containers"
  homepage "https://github.com/GoogleCloudPlatform/container-diff"
  url "https://github.com/GoogleCloudPlatform/container-diff/archive/v0.9.0.tar.gz"
  sha256 "cf5957fd9c583030283982dafab0b70608c739408d036444d9acc0a867e7472f"

  bottle do
    cellar :any_skip_relocation
    sha256 "e809e868ab051d530d310d9a550124dc1dbc429d6bf2a9e7306922720504c73e" => :high_sierra
    sha256 "e8f9e5795ac47eec3f8ea0ad4613d6955ab377d74fd14402b7079ea45ebe45a7" => :sierra
    sha256 "17be75856c9de704f3ef866c8d71ca07ee03ed2f2e71efa21821e20fc078feac" => :el_capitan
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
