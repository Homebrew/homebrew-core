class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/3.4.5.tar.gz"
  sha256 "5d624d7751286789fcbd86d5494de06c628b80c6eb1bba2fe469b1189ea30665"

  bottle do
    cellar :any_skip_relocation
    sha256 "3dab78fb83dd7efb1f2309913857f7cdf1535bc91f065d9c9ebc46c9fb679200" => :mojave
    sha256 "a7615185964e137601efbe0994c081f4c6f57f4e0e286c9ea994a3fb18553227" => :high_sierra
    sha256 "a92a9ee4ddecd2b85925aac3f5e30420dd4b2ca3abf6d5e55718e02e6222e11b" => :sierra
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
