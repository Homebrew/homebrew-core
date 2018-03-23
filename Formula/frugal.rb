class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/2.16.0.tar.gz"
  sha256 "5c7dce490ad275f02247f087900a3050d421cd3cdf25d1f3264ed10e62e383c4"

  bottle do
    cellar :any_skip_relocation
    sha256 "2410ee4817b223043be7b7ecb4e46f59210b0705ec849d569cb7cdbe10c1e5d3" => :high_sierra
    sha256 "77478290ae8cc2af3808a109fdd202aff50a5fee92be35c77a7f6c9c3d970dc3" => :sierra
    sha256 "39b7a45b4542967894dfe888c4f5742015f993e03b94c7b3b27bdff5e982d3fd" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "godep" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/Workiva/frugal").install buildpath.children
    cd buildpath/"src/github.com/Workiva/frugal" do
      system "godep", "restore"
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
