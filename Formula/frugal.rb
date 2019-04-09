class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/3.1.1.tar.gz"
  sha256 "656a0a983d1a409d2730a0a07dbc48ce5fe746954053cf5fe6e339a56a6ef48e"

  bottle do
    cellar :any_skip_relocation
    sha256 "6c9a709797c91c24dcb4c9b4889a74e891dddcf49a8eb78773a374be722039f1" => :mojave
    sha256 "20b3c4658a91bf0444a071639e5e612aa632baec1a58532e9d750462c2f772f7" => :high_sierra
    sha256 "1043889fd464831e25cc88df70d58ff730b27b017771b9e9b9e48665a7ebd48b" => :sierra
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
