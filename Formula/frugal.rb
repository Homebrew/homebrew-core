class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/2.13.1.tar.gz"
  sha256 "82e0f7a0fca33189e7f052ba3c6dbbd6f2ff5f559223fa7db5881ef1b6478d50"

  bottle do
    cellar :any_skip_relocation
    sha256 "99799e0250aaeb79321cf05cc458cb899daa44b7cf8c42ae7bf36ac8c690d94c" => :high_sierra
    sha256 "ba0724451d0ee7178b7945275d8c8079b8ba460e079915b519f8c65459cac53f" => :sierra
    sha256 "a04f458ba6d2e5d8fa99988acf4cf2e2293786a07a4f9212b264e6cf0a40f97d" => :el_capitan
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
