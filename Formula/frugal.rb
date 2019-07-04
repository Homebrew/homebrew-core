class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/3.4.2.tar.gz"
  sha256 "fd650a6972a6f0506574efa26c202af870391ddd1b5a9daf4319ffe83f79f555"

  bottle do
    cellar :any_skip_relocation
    sha256 "e68a5198a44acea7f0d174a42fcf865c63a0af0de2e6207ebdd4a1a330ca988e" => :mojave
    sha256 "959fef91cddb4ed7cea79057b1bbba61be6f201a35c3c889b279952963f5d035" => :high_sierra
    sha256 "ca9db51ac42654b55b511f53391ef5bdddf2feda090cbbb44e1900ba1f8f27e4" => :sierra
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
