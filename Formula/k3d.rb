class K3d < Formula
  desc "Little helper to run Rancher Lab's k3s in Docker"
  homepage "https://github.com/rancher/k3d"
  url "https://github.com/rancher/k3d/archive/v1.3.2.tar.gz"
  sha256 "c6f31d99a47f62f76e276f2ca5801602c95aec8969b263a8784589ead90a378c"

  bottle do
    cellar :any_skip_relocation
    sha256 "d174f38bc2bd4e0424a8f642bca6031181e8ea27379f91c6a2ca64c02efc3a39" => :catalina
    sha256 "20e861256deba99823552a949b4ab55126a901c93575edbf75b0da9dc657edc2" => :mojave
    sha256 "5d229d391480e3f1812a0ab9d2221866050c1283e971be2ecfb83cab7286940c" => :high_sierra
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
