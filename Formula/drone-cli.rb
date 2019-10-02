class DroneCli < Formula
  desc "Drone CLI"
  homepage "https://drone.io"
  url "https://github.com/drone/drone-cli.git",
    :tag      => "v1.2.0",
    :revision => "f9fd3fe42bdfa015f2da700de8d00cecbd8adc1a"

  bottle do
    cellar :any_skip_relocation
    sha256 "93e10a2deb01cfffbcb2e1912c9f3ae5acad176ffef865452b9cb4ec14d08dd5" => :mojave
    sha256 "57310b464cdb63d6eb63d522b743ed339b10308d4fc72ffe758e6d987bd6af50" => :high_sierra
    sha256 "9aa164f7eaf7867ecf1f40a69379028f730c2bce606cb33e2e9975145a610a80" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GO111MODULE"] = "on"
    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/drone/drone-cli"
    dir.install buildpath.children

    cd dir do
      system "go", "build", "-ldflags", "-X main.version=#{version}", "-o", bin/"drone", "drone/main.go"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/drone --version")

    assert_match /manage logs/, shell_output("#{bin}/drone log 2>&1")
  end
end
