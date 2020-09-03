class Lego < Formula
  desc "Let's Encrypt client"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego.git",
    tag:      "v4.0.1",
    revision: "99b2cd818167175c8933ff121e613f8b68690f0e"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "8752def187b7dadb167a45282f6dce99e716bba5116ce795f52d1a442db7e07b" => :catalina
    sha256 "0731aacff85f51f12d5626470430a3f75b1051b2c1dc1c955c60c17328310a88" => :mojave
    sha256 "18d1f2c2fcf2d71d0f1b9a0f5364e695145c42c7617e9bb365b1fb405979a974" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X main.version=#{version}", "-trimpath",
        "-o", bin/"lego", "cmd/lego/main.go"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lego -v")
  end
end
