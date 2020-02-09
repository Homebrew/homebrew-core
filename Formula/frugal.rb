class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.7.1.tar.gz"
  sha256 "b3677707ce08caf337ac9965df2f6af3cefd5d94df28f666687c9cc90779524a"

  bottle do
    cellar :any_skip_relocation
    sha256 "114c2fa488e5bd8998348a2b5318eb0ef823438cf3bfc88feed755ba0098fceb" => :catalina
    sha256 "15e01814ddb35e387233648684f471df8b78498feccfc6fde470c635b83a9d0e" => :mojave
    sha256 "8c4fc76ac1f8c2171060a7434177b3faa465c698a5c5e101cc932f2581e70c60" => :high_sierra
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
