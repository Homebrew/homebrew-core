class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.9.6.tar.gz"
  sha256 "579aa376d6e9f8c406a8f8ade0635d8eae807337a12c6189633225763e221cea"

  bottle do
    cellar :any_skip_relocation
    sha256 "8335938e474c070b991ab75ee77f9791b9dcbf2e1fc5ceb6673e29ed2bd7fa71" => :catalina
    sha256 "5f95ea0b8d4b6634abee24e230760b6a5826bb9082d17971684d85508a6f313f" => :mojave
    sha256 "dd0dd62bc718200ca50b6d67896f84fc8a323fd35927ca770d4386aed7d5aec3" => :high_sierra
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
