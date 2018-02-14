class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/2.15.0.tar.gz"
  sha256 "a76159656a1f8fd5bbdda55e950f0220e6b395ceb0136442cd46837e70aaa5ba"

  bottle do
    cellar :any_skip_relocation
    sha256 "7ff242bcf7847d3ac844cd105047158d95398704c9b2fb956e3a3bfc7772a848" => :high_sierra
    sha256 "ea7e52b0d29804a5025815b844fca162d49fb88233f836b07bda262b64700344" => :sierra
    sha256 "09b443de900a1d49a5faa42cbd58aeff9f6ca9492af5f22c811441d44408b285" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "godep" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/Workiva/frugal").install buildpath.children
    cd buildpath/"src/github.com/Workiva/frugal" do
      system "godep", "restore"
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
