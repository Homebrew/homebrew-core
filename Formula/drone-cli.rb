class DroneCli < Formula
  desc "Drone CLI"
  homepage "https://drone.io"
  url "https://github.com/drone/drone-cli.git",
    :tag      => "v1.1.2",
    :revision => "3fe8b173e5dec8257ad6239fa21a255e7b78d5ef"

  bottle do
    cellar :any_skip_relocation
    sha256 "0a39a7c6158401537deed40fb3dc4bc63b1236ac734c67745c7082d2c3ffabc2" => :mojave
    sha256 "4cb5e6e0e70f54795b24799941609840ae1a3802420e71c1031778d49d9b2033" => :high_sierra
    sha256 "46de83655b34fce4f74e40f008f26bc353251cac018652192ec6f8d2a085d89f" => :sierra
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
