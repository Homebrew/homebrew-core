class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/2.21.0.tar.gz"
  sha256 "007fdc0538b26db201f21779d02981c45ced3609a46604adb5b164d028a859ec"

  bottle do
    cellar :any_skip_relocation
    sha256 "ff36249833c4df543e4c713f54c63e7e2f634392f080c071ec6ef91bc30dc04a" => :high_sierra
    sha256 "8a18ad48ed0c591c33c974b483cf51f6d6efd5f3dbaf73dea6239fa734ad1709" => :sierra
    sha256 "41c1771de39fc1cb7ab18279edd523db67c6455f590336cf59e66f9316054d39" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "glide" => :build

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
