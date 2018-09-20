class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/2.22.1.tar.gz"
  sha256 "aace3b1f2a7c4caa4a3b45f7fac01669423907fab6d222ef73ba71a0de60b164"

  bottle do
    cellar :any_skip_relocation
    sha256 "bc4ce70cd8c3c40a78648d87a555c3843d804fee1309c665493258506523f6b5" => :mojave
    sha256 "c62df7633a28175a38baad6d218a1d70dd49cc97c085733a84a382078c7501e8" => :high_sierra
    sha256 "b0a6a13b9d76440fffaaf74e01a224e4fdd39b36d84e7b27da98ea8cec65875d" => :sierra
    sha256 "b06dea3776f6704742c7db06adb4fdc6e7c1addb68891a2c8fc540f046dcf661" => :el_capitan
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
