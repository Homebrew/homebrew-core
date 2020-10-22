class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.12.1.tar.gz"
  sha256 "e01c8d643096e8ec0ceb22852e4065312b32aa3c0fe84808474c3583594646fa"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "6ac740342c912fceab7ab70e51c39bbc68698250fdd4007614ae6129f399aae9" => :catalina
    sha256 "7e4feac8be9f0e0cd40a6b415d10f9d5505e68f9d8c986d00b665adf8d5d963a" => :mojave
    sha256 "80e817646f66bdd4d7659548a1fd3306f547e4411eb9c30225a8728f14611932" => :high_sierra
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
