class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/2.11.0.tar.gz"
  sha256 "1e3d793e733d41052652df99b60124d9cab64903b80f0aaf319ba7d5e3a4b6d7"

  bottle do
    cellar :any_skip_relocation
    sha256 "ea9306edd34465e5050dd18afabaf2c3189200b4a97ee7966929e4b8085a01f7" => :high_sierra
    sha256 "9410b681e5f6d324ab141e26a105695320ae7cfbb2fa27e583c9b708f1d2a08a" => :sierra
    sha256 "eaaf2f0025b2855a9338be5fd3ca1bc2b60346f2ab8a10f7da65393d703fa8f0" => :el_capitan
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
