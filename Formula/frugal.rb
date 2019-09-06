class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/3.4.6.tar.gz"
  sha256 "0d5c1b8008ad1da1ffec2389ef116e3b7a088e5e5e2ee7117b7ccf2e6270b861"

  bottle do
    cellar :any_skip_relocation
    sha256 "bb2656abdf801c1a37ef1ba3ff4d463177859b10a5fddf4ff771f276819b2677" => :mojave
    sha256 "f24d17778fcbe8ba3099fbc7409fe3d26071869c13aa678214bdfae9fe17fb8e" => :high_sierra
    sha256 "2d80142ff6d54cf463a3c3f1bb31ce9de2810008818edf7eabd99f8a903936b9" => :sierra
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
