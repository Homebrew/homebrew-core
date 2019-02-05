class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/2.27.0.tar.gz"
  sha256 "d6d0d0f72a58f4d94ec0ec19c95bf8cdbfba558e4f3d127ea4548ac8a7f227fa"

  bottle do
    cellar :any_skip_relocation
    sha256 "052c48676944acaffc8ac0cd77f571acfdb25e6bcf068049a4fd0aa2b5ca6d5f" => :mojave
    sha256 "d01b86cd071fc23937430356940b6a797055759576469dbff1367ee58f319780" => :high_sierra
    sha256 "ad80fc17ee200aac5c72529052d80fbaa87d03d08137bb4f4e891326f2f6d681" => :sierra
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
