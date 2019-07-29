class DroneCli < Formula
  desc "Drone CLI"
  homepage "https://drone.io"
  url "https://github.com/drone/drone-cli.git",
    :tag      => "v1.1.3",
    :revision => "e9c3f7c6f5d89fa5dbfc5b8a1869af9e864a86e1"

  bottle do
    cellar :any_skip_relocation
    sha256 "b5d1dd6aba158729e8b160c9e81f36cdc99793119203ce4722301cc784d50fdf" => :mojave
    sha256 "f50eabb263db692a49d1f630bfa5dda5aecfb86873b5ad3ff9264048e8bb6113" => :high_sierra
    sha256 "5d4cc05f72098cbcf63adaf2041cc2f0be9bba74ba663fe703b0e8fa72954b6f" => :sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/drone/drone-cli"
    dir.install buildpath.children

    cd dir do
      system "dep", "ensure", "-vendor-only"
      system "go", "build", "-ldflags", "-X main.version=#{version}", "-o", bin/"drone", "drone/main.go"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/drone --version")

    assert_match /manage logs/, shell_output("#{bin}/drone log 2>&1")
  end
end
