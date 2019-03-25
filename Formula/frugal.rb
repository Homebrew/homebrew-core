class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/3.1.1.tar.gz"
  sha256 "656a0a983d1a409d2730a0a07dbc48ce5fe746954053cf5fe6e339a56a6ef48e"

  bottle do
    cellar :any_skip_relocation
    sha256 "fa0a409b76f203e416ebe8163c344238085634ca16cb7aea986726c7c01485fc" => :mojave
    sha256 "94a4ea45c10c9bec668a739fbd461850bb482a21b72f76775a9f6f044ac50390" => :high_sierra
    sha256 "dce7014f557f021da1a763ff294ceb0f0f0b9fc74f09075b44e5bf9228e8c341" => :sierra
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
