class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.9.8.tar.gz"
  sha256 "74a7410048ede40aae92bab9834920ef1442291c30e57fbc956b871d4176814d"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "5af2ddbec8f1f5d8f199c466d7c146a08645030311856dfa62c6b9ca469527a9" => :catalina
    sha256 "60c3175319b35fb5caa91e0f01abe6becb5d4a3456e968ca25bf1cf5b28c6650" => :mojave
    sha256 "6225fe9c2da081c2ba62e520c779cfc5e7bb11af6a65725cd27af8aa9566709d" => :high_sierra
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
