class Lego < Formula
  desc "Let's Encrypt client"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego.git",
    :tag      => "v3.6.0",
    :revision => "71d61f880cda82c30986ee9ed2e05da62881e84c"

  bottle do
    cellar :any_skip_relocation
    sha256 "6e0ea4d6a806f4c51c7847c327b11b503d927276c66c76fd9d39b2eb980274af" => :catalina
    sha256 "9c7fad89ce5a57315aaa78264548a5a6e0ef1905cce33ff1f6b24b4ec79558a6" => :mojave
    sha256 "b6c138dc5b91f23876e908f37666141986912e240ced6d4e453f7b6210def2a1" => :high_sierra
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
