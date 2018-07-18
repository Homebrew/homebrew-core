class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/2.20.0.tar.gz"
  sha256 "86e81a7144521697be0d1b79b2b6072d228671930ca16bcdfc7969d6200faf8d"

  bottle do
    cellar :any_skip_relocation
    sha256 "10f9c6f8f52b6a26f4c09db3a1df9bf1c197bfc88ad8dddad42d0e5b8672c676" => :high_sierra
    sha256 "84662e04709db4561a4dafa3430e7a7a853777aac2f7dde8929b28ec7d31b1b0" => :sierra
    sha256 "ad977114f4324a4d40a4194954f494178bb116a28e06a16a55aa0d1199034f1e" => :el_capitan
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
