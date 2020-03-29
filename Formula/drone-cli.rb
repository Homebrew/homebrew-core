class DroneCli < Formula
  desc "Drone CLI"
  homepage "https://drone.io"
  url "https://github.com/drone/drone-cli.git",
    :tag      => "v1.2.1",
    :revision => "a5f8e7c245635a3855cebfde61c29b805d0b46a0"

  bottle do
    cellar :any_skip_relocation
    sha256 "6f6c2e86acf8190aa34f419213a622ac59c6f1b7848743b5066baebc89402605" => :catalina
    sha256 "6f942cbf4739e14966324724d37dfb422bfc22949c5aec9ed568f212f8ff88ef" => :mojave
    sha256 "2e3947c81733f0b548815fe37601551165ccb1f8d49df7f49b3b0671529f4e22" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X main.version=#{version}", "-trimpath", "-o",
           bin/"drone", "drone/main.go"
    prefix.install_metafiles
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/drone --version")

    assert_match /manage logs/, shell_output("#{bin}/drone log 2>&1")
  end
end
