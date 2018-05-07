class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/2.18.0.tar.gz"
  sha256 "aadd06371d3b0d2da29924f86e6abda1ae262459d00e566b9f5d605bf38982a3"

  bottle do
    cellar :any_skip_relocation
    sha256 "0b0bececd988cbaefd71487ded98c87c8b7ea63a34ed9546a2e7c93db257b691" => :high_sierra
    sha256 "5e9a62c331b37308c7608f4aeeedcf5edfba2ebe25057a1aee3990208404f146" => :sierra
    sha256 "50ddce0dc0d076dd31940336b8c465b3036e8e14da79484721e9d8d5f62ccfd2" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "glide" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/Workiva/frugal").install buildpath.children
    cd buildpath/"src/github.com/Workiva/frugal" do
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
