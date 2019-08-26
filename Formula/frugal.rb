class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/3.4.4.tar.gz"
  sha256 "de895afd26c200b4cd79fd33fb87b9dce13834fb29b6ecbc5a03a4e2f15339ac"

  bottle do
    cellar :any_skip_relocation
    sha256 "e3f89e297f2188d60a8b78ee981f0431d68933b1ec045e2afa1d4c081622ab29" => :mojave
    sha256 "4334d467453e88874d17588069c149eff4c59ef32c6171e60cf722620c72a142" => :high_sierra
    sha256 "1140041549e11080f8ec10d53f6107f5ae4937b65deb2df6b543cddf2e59ae43" => :sierra
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
