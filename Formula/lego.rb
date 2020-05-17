class Lego < Formula
  desc "Let's Encrypt client"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego.git",
    :tag      => "v3.7.0",
    :revision => "e774e180a51b11a3ba9f3c1784b1cbc7dce1322b"

  bottle do
    cellar :any_skip_relocation
    sha256 "6c14c2eb3f44a4b27a41da151e6d68ba11e718e1d87039c37e11dc2e4be31bcd" => :catalina
    sha256 "2bf6365d16cb7313b07f8b8624b623e7eef052616d25f5f8a597fdc5ca059b3b" => :mojave
    sha256 "2fb52d671d0a59ace03d63866ee897c87d0ee9cd6eb5953860fe28bdaffd17b0" => :high_sierra
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
