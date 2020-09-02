class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.11.0.tar.gz"
  sha256 "68f9af8be9d5268b42240d13ea8d1262591b75fd403f1ec48dad62911b86a27b"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "d560e1781e3b05039754fbb6e62151d109d858a918e788c095f642100cd5f290" => :catalina
    sha256 "3b952f0f4ef4d7715c751c0821f4eae1db7ea12b8654d562cb4270129f31b7ac" => :mojave
    sha256 "f6aa7c823fd4f5b446803fc7b08cec70e67e9ff1910f3ed020038081a865d814" => :high_sierra
  end

  depends_on "glide" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/Workiva/frugal").install buildpath.children
    cd "src/github.com/Workiva/frugal" do
      system "glide", "install"
      system "go", "build", "-o", bin/"frugal"
      prefix.install_metafiles
    end
  end

  test do
    (testpath/"test.frugal").write("typedef double Test")
    system "#{bin}/frugal", "--gen", "go", "test.frugal"
    assert_match "type Test float64", (testpath/"gen-go/test/f_types.go").read
  end
end
