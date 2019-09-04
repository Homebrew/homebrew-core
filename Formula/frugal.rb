class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/3.4.5.tar.gz"
  sha256 "5d624d7751286789fcbd86d5494de06c628b80c6eb1bba2fe469b1189ea30665"

  bottle do
    cellar :any_skip_relocation
    sha256 "254995fa5992128d0283e69a3970cf6f0f81f4a70338efa087b44926b7be8490" => :mojave
    sha256 "e02c66d4f177812258c00ed8f3f5c35068a7966edea51446f49c348814346f37" => :high_sierra
    sha256 "5c0060d471aa168be6c20207985ddb9f5e2ad11a642ce6239cef03cde7fd3aa0" => :sierra
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
