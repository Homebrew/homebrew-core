class DroneCli < Formula
  desc "Drone CLI"
  homepage "https://drone.io"
  url "https://github.com/drone/drone-cli.git",
    :tag      => "v1.2.1",
    :revision => "a5f8e7c245635a3855cebfde61c29b805d0b46a0"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "a0661b38156217550cab8512d9c16f51e28c68223afb0b9abca7b4c039a1b0fc" => :catalina
    sha256 "15a4a8121d517816693c700e107099a3d6afbb1ef188ed2269d68e4d5a154b77" => :mojave
    sha256 "df3f7884560e17997fd85c9984f88510f7a9d5bf7f26f2d0e93700819f453989" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X main.version=#{version}", "-trimpath", "-o", bin/"drone", "drone/main.go"
    prefix.install_metafiles
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/drone --version")

    assert_match /manage logs/, shell_output("#{bin}/drone log 2>&1")
  end
end
