class Lego < Formula
  desc "Let's Encrypt client"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego.git",
    :tag      => "v3.7.0",
    :revision => "e774e180a51b11a3ba9f3c1784b1cbc7dce1322b"

  bottle do
    cellar :any_skip_relocation
    sha256 "1f28d7b0efe03365a9fb281c9ea680a5e9715d43cb6bd8ef99b18ac0def3a105" => :catalina
    sha256 "8602e35affcfc310f79723eccffbb6da9e87d9dab69537b1ae86831c1a4b702c" => :mojave
    sha256 "af3237e22b689aa1428f85b2f4a670f3a43e860019865825bb45c86231e18a6e" => :high_sierra
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
