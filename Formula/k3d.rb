class K3d < Formula
  desc "Little helper to run Rancher Lab's k3s in Docker"
  homepage "https://github.com/rancher/k3d"
  url "https://github.com/rancher/k3d/archive/v1.3.4.tar.gz"
  sha256 "3d6c5d64795e4b459f236c391dd24e1ff08fcb2bf29e914509c8ddf8f699bfe7"

  bottle do
    cellar :any_skip_relocation
    sha256 "98fc996c777fe79b6ba0260cc7ef0e12c0961ee1462dbef12eddbeda8bb13fd3" => :catalina
    sha256 "3ad2b2ea2584c46837dcd958fa0b384bee15f193d85df3025c2b7d476429d6c6" => :mojave
    sha256 "3cb8ca78ded4bd85a41c4869ff6932a912368479d3c4d8ee73a7d77c26f589c5" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GO111MODULE"] = "on"
    ENV["GOPATH"] = buildpath
    ENV["CGO_ENABLED"] = "0"

    dir = buildpath/"src/github.com/rancher/k3d"
    dir.install buildpath.children

    cd dir do
      system "go", "build", \
          "-mod", "vendor", \
          "-ldflags", "-s -w -X github.com/rancher/k3d/version.Version=v#{version} -X github.com/rancher/k3d/version.K3sVersion=v0.10.0", \
          "-o", bin/"k3d"
      prefix.install_metafiles
    end
  end

  test do
    assert_match "k3d version v#{version}", shell_output("#{bin}/k3d --version")
    code = if File.exist?("/var/run/docker.sock")
      0
    else
      1
    end
    assert_match "Checking docker...", shell_output("#{bin}/k3d check-tools 2>&1", code)
  end
end
