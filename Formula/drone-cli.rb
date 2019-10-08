class DroneCli < Formula
  desc "Drone CLI"
  homepage "https://drone.io"
  url "https://github.com/drone/drone-cli.git",
    :tag      => "v1.2.0",
    :revision => "f9fd3fe42bdfa015f2da700de8d00cecbd8adc1a"

  bottle do
    cellar :any_skip_relocation
    sha256 "cde21f2a1c918e095f138b6cccc9870c2a1a76bee8a9a8e3dbee33ab4c54bfbd" => :catalina
    sha256 "a059cdbe892dd4a7058636503d690da54ac8fab3eaeff7d1ae32e07229282b1a" => :mojave
    sha256 "5753b74f0c5ede30868d431cc877f934eb5e10a7bc59ede9da54d2f3b785fa8b" => :high_sierra
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
