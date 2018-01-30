class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/2.15.0.tar.gz"
  sha256 "a76159656a1f8fd5bbdda55e950f0220e6b395ceb0136442cd46837e70aaa5ba"

  bottle do
    cellar :any_skip_relocation
    sha256 "547a305f68590324439c4f0c8904b687e8752760299b1a0ba420651177fb919e" => :high_sierra
    sha256 "de25e7d5eb75a9c09fbdad3878a780ebfe681e9d91faa181e356c67f6863d050" => :sierra
    sha256 "f2e2f94c662e0d5f24f7bb89cef4fdecfc41031587253134b986fd7f04aeb10c" => :el_capitan
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
