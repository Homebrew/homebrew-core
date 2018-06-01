class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/2.19.0.tar.gz"
  sha256 "97b50addfc26b4edbcafedec2be79b095eab0abd7b277d0e6e1b6fa882d55351"

  bottle do
    cellar :any_skip_relocation
    sha256 "1fbdff3d37e713f985376b9019c9d32fe8ea5dc214f86dac21d0470d37253807" => :high_sierra
    sha256 "86d9138cdd308eb25f781eaff3efa7731e393a8c67f73ae0d9e85aa8e05da5d0" => :sierra
    sha256 "6640d809b65fe4f1e62508325e3644945df63d22dac1a9e8ea48c4a33da8b5b6" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "glide" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/Workiva/frugal").install buildpath.children
    cd buildpath/"src/github.com/Workiva/frugal" do
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
