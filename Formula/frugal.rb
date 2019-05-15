class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/3.4.0.tar.gz"
  sha256 "7d536b15ec95a0f9d4cf1b98dc18596197e2ccbc1894595c3f3cb5d9346d3077"

  bottle do
    cellar :any_skip_relocation
    sha256 "deead2656bdc92f9093c03f668011bf922cb48ac0cb827834c6b18c794e7417c" => :mojave
    sha256 "187c9906e29e5e4f3b2b296cd9fb179e545171ae13dda68391efa002c2af61a6" => :high_sierra
    sha256 "e9d70046c302a410204bf5a3251ffe6bd4f9b997abc42872df19d961a49e1b96" => :sierra
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
