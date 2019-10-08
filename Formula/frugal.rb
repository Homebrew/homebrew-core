class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/3.4.7.tar.gz"
  sha256 "718a9ebd5d553df580272006132a9cca64697b3813e82537dd73c51d969d03ad"

  bottle do
    cellar :any_skip_relocation
    sha256 "2cb1fb5e407e23b1ba573aaf1b13f4f4f76972bf6e062b046b85b3cf35473e7e" => :catalina
    sha256 "c821bbab957feec170c237f38659d850a544f9d041459802089c67e345983789" => :mojave
    sha256 "a7db0104f37484200cc07e89700d1a9cc45deeb602a9ed0102e434eae5193001" => :high_sierra
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
