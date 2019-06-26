class DroneCli < Formula
  desc "Drone CLI"
  homepage "https://drone.io"
  url "https://github.com/drone/drone-cli.git",
    :tag      => "v1.1.2",
    :revision => "3fe8b173e5dec8257ad6239fa21a255e7b78d5ef"

  bottle do
    cellar :any_skip_relocation
    sha256 "c45a40ac12130a4dc15a6bcb41a33674b532736b5e30494f196e6c1dd0b5f38d" => :mojave
    sha256 "7c30b8d8e8b257501d55e478fab4b9ef7601cc04f26c83b5d89e34f7e0f5a038" => :high_sierra
    sha256 "7acd0eab3d379a33206e17d9c99386d9412ac38d65aeb871b7a6c426a3cf559f" => :sierra
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
