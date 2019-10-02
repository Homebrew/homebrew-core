class K3d < Formula
  desc "Little helper to run Rancher Lab's k3s in Docker"
  homepage "https://github.com/rancher/k3d"
  url "https://github.com/rancher/k3d/archive/v1.3.2.tar.gz"
  sha256 "c6f31d99a47f62f76e276f2ca5801602c95aec8969b263a8784589ead90a378c"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "9b919b2795e4562f5c404ab966c594de3d4098458e5667a02d8ccec486e29e82" => :mojave
    sha256 "f43c8687dd14dc9541a6398523ac6a962d37550070904bee9343273821ab2d0a" => :high_sierra
    sha256 "8c72b8886ecbca9c9333b16b184627d642ce6f6afd8c6eeea2ff7ce70260dd45" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GO111MODULE"] = "on"
    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/rancher/k3d"
    dir.install buildpath.children

    cd dir do
      system "go", "build", "-mod", "vendor", "-ldflags", "-X main.version=#{version}", "-o", bin/"k3d"
      prefix.install_metafiles
    end
  end

  test do
    assert_match "k3d version dev", shell_output("#{bin}/k3d -v")
    assert_match "Checking docker...", shell_output("#{bin}/k3d ct 2>&1", 1)
  end
end
