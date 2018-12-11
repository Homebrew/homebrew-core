class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/2.25.2.tar.gz"
  sha256 "5df21c7ba14eb2696d63dd72140ce6baec3f28dd549f0d464c222b3178a44f0d"

  bottle do
    cellar :any_skip_relocation
    sha256 "7ca1f7ab67e7326c2254cf8807937927f011f0d33465c71582dc65a120a3aad4" => :mojave
    sha256 "2296268614d59cfe4a20181e23e0e6bd9fdf0e15e6fe11139255b00eaf377025" => :high_sierra
    sha256 "3a0adecd9f120e99a6c9c3f7d4d56a41a1ea05342578cfd344fca5ae85f85c81" => :sierra
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
