class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/3.0.0.tar.gz"
  sha256 "ad1f1473ef07341c6bb4905774afb2864bd2a7c8164cec8319f6d581d9bbfc9e"

  bottle do
    cellar :any_skip_relocation
    sha256 "553730e9fd529179839a9f01973dd35777886561df06e9ec8034b10b74b8ae0c" => :mojave
    sha256 "aba166816c43941f8b3fd8b04ea39a69b102e3977741686b8fc4a44af323b8ff" => :high_sierra
    sha256 "5a23895b848a0012b3f38d0384a54412ea2f5b3ec105d478e55e6c00d115be0b" => :sierra
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
