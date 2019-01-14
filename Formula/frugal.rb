class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/2.26.0.tar.gz"
  sha256 "cf4386de5cc872de044dd1d160d1e0dbc001f034e6a1f01c88ad18f07ece9c85"

  bottle do
    cellar :any_skip_relocation
    sha256 "74006b2ee44e03f3c22dbe956bc51a1a1b1ef9a687c9d82fb93139793120d0b4" => :mojave
    sha256 "586cdb283f0f1750cb99885f1e30de8448e7a71605647f2e9b189e71daaa00a5" => :high_sierra
    sha256 "07aae904bd11d273347c50d2e356cf850dc521e4123e76327c1e15e961487e9a" => :sierra
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
