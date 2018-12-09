class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/2.25.1.tar.gz"
  sha256 "63c517a621fdcb23ae6f9762c869caca28dc91144bcb02f0eec5963233bb6c98"

  bottle do
    cellar :any_skip_relocation
    sha256 "d2fa5fb0963bfc86088940ccadd3e97db7ba909655d187a2f1de1b04e400a977" => :mojave
    sha256 "b0db64e3c102e5d6efa2bcc5b2b88b175a24e3b167545897733330ed284ecb1d" => :high_sierra
    sha256 "2b2868bbc97678dd925e9113aff26107d52e4bbe0ca651911a70fff7b9a296da" => :sierra
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
