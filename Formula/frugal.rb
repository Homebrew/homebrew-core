class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.13.1.tar.gz"
  sha256 "d71b48ba6834b62ae5f52b7f50cd768af5a483283c0deed043ff4c6dde3f2344"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "b5091ce489760e134a319e1fd95876074e2570aa6df5ab4a5162c04917bf172e" => :big_sur
    sha256 "318f2abc0180a6145d07df9eb38392d188ce73941b48a69f8327d073912c05c1" => :arm64_big_sur
    sha256 "a29e67a857b219d854cca711dd47b7bf3a0c8762b57512334fbed946ff74a6d0" => :catalina
    sha256 "5e2e9a28e4bfea849d62a88a309082f8ec1c40a6f7db6b68df0ebde1f88aec21" => :mojave
  end

  depends_on "glide" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    (buildpath/"src/github.com/Workiva/frugal").install buildpath.children
    cd "src/github.com/Workiva/frugal" do
      system "glide", "install"
      system "go", "build", *std_go_args
    end
  end

  test do
    (testpath/"test.frugal").write("typedef double Test")
    system "#{bin}/frugal", "--gen", "go", "test.frugal"
    assert_match "type Test float64", (testpath/"gen-go/test/f_types.go").read
  end
end
