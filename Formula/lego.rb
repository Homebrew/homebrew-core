class Lego < Formula
  desc "Let's Encrypt client"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego.git",
    tag:      "v4.1.1",
    revision: "fca2a4564fe913f8cef61612a16b7b3d0f1e3bae"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "5370ccf8d7b81bfe09d789185e06cf7300f1c3cbcc5a1872124b052371299089" => :big_sur
    sha256 "8854fdd538be584adee20ac7557bc388ccfdbe25b61c691029a852b2c172dec6" => :catalina
    sha256 "ac99caafafc5ed6e8690db56361a940558db7ca4e6ac473ad53f73f42b3f26a4" => :mojave
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
