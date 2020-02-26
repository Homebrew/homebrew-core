class Lego < Formula
  desc "Let's Encrypt client"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego.git",
    :tag      => "v3.4.0",
    :revision => "bf1c12479ec95100c017061c9ea857cea7b94c34"

  bottle do
    cellar :any_skip_relocation
    sha256 "30dea0a6027acd8ca7e69f5075729ad3a65f2ef3820191139e30d3f0d43f07e6" => :catalina
    sha256 "f178e501b24c5bb77636dc2d6d9ffb81466cde43a61517b219b5aeba4db33077" => :mojave
    sha256 "a896c91af26c66658cb5956eb0e561cb7ab5dfbe1b7b6321f40924a4ebc4263a" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X main.version=#{version}", "-trimpath",
        "-o", bin/"lego", "cmd/lego/main.go"
    prefix.install_metafiles
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lego -v")
  end
end
