class Lego < Formula
  desc "Let's Encrypt client"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego.git",
    tag:      "v4.0.1",
    revision: "99b2cd818167175c8933ff121e613f8b68690f0e"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "f4811a1694e1bfe2dbb2fef4ea3a44cbb0d6cba4940b3c4f904f515d2c3d7469" => :catalina
    sha256 "7dfbb0d990526cbd5f6db396cf16eada4f6675021f9917eab7db050f8bb21fc1" => :mojave
    sha256 "7946ea0f32c17de5af07144533fb9982b0183bfa1973e3c0e1f48ce1d49cce3a" => :high_sierra
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
