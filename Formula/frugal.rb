class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.8.2.tar.gz"
  sha256 "d28f02c70dea32a41a1311097001998ca2dbf59c377efba10670e53b279a0253"

  bottle do
    cellar :any_skip_relocation
    sha256 "f181e64c087bed0cacb9f7b1642f55e20055db9c6f1ef13176308a144cd07a83" => :catalina
    sha256 "24ba7f331eccaf45bf94249d82afd458793ef5e2424d2242ffa8d030916c6f0d" => :mojave
    sha256 "2639d26e1df19e35b1e812bbfbd5ffc8311fab6fde6465015680325758b4522f" => :high_sierra
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
