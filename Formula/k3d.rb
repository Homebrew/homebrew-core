class K3d < Formula
  desc "Little helper to run Rancher Lab's k3s in Docker"
  homepage "https://github.com/rancher/k3d"
  url "https://github.com/rancher/k3d/archive/v1.3.4.tar.gz"
  sha256 "3d6c5d64795e4b459f236c391dd24e1ff08fcb2bf29e914509c8ddf8f699bfe7"

  bottle do
    cellar :any_skip_relocation
    sha256 "0d6f15dfdc46bbda0a2b4b07503c65e2e047a91490b742401c6c65cc65fc28c7" => :catalina
    sha256 "d2f50bb1aa5c9b6f0cdd3b6996be133d1ca78ce02ed2904fbf6ccc81d7e7c070" => :mojave
    sha256 "84dc8df4801b2e1ed3d15594eeed4ab99260b0a0faca1b42212a9190510a3646" => :high_sierra
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
