class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/2.20.0.tar.gz"
  sha256 "86e81a7144521697be0d1b79b2b6072d228671930ca16bcdfc7969d6200faf8d"

  bottle do
    cellar :any_skip_relocation
    sha256 "2e35835fd41519f4ab872b71f91cd52a23326eacbcff9129deffe5d83567f4f4" => :high_sierra
    sha256 "9f9f48cac9a995bf207b87522388ea26562388d585e066201fa2105b393b2b1c" => :sierra
    sha256 "b2f865b5bdb21a11b67f587010e63c7a68cdfa5dea78ca3c6774b0d1c7c10944" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "glide" => :build

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
