class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/3.5.1.tar.gz"
  sha256 "14b2d5a0e38c55df6d9d19c321747e62e9f68689d40f2f99de2f2a4ddbf6131d"

  bottle do
    cellar :any_skip_relocation
    sha256 "87e922e5751cd8f2b8b69c2850d7822dd0bbae48870aaf3018f4fefd03563e4a" => :catalina
    sha256 "3fb01fe7c162db6f9a1293a80b393383948a2c59a0992aa66e9b3f919f26df03" => :mojave
    sha256 "e7d5bc8e1ef85b498a6e40aa75c202b9cddebdc48ffd5b9d76c95ad698375a53" => :high_sierra
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
