class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.9.9.tar.gz"
  sha256 "e7ddafb70f8413fb62f4d4760437bdc881c4da4a903e8c4fa22c7298ca0cc98e"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "a18fb61f92432c7449f345a7cc38de60c4265a9cd1bc0e136aa44a0cedff607a" => :catalina
    sha256 "9d98b771e79ce21e380a498cfe0234324d1f9e4416917303dad9366e63f3c9c0" => :mojave
    sha256 "006fb4433a47e988ddf78894674a83733179821c52f4c5674375c17c503a1409" => :high_sierra
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
