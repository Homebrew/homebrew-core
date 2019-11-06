class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.4.9.tar.gz"
  sha256 "a363070071b9f884f7dd192065f829d66dee8fb6ae0c72e1f25e06eadabb8df9"

  bottle do
    cellar :any_skip_relocation
    sha256 "a1f6fcd68406616345399ff1d98ce6e0a1d0485b1fefab664eedca0968261303" => :catalina
    sha256 "83a3e37e7cd5f07393f84a61bc9a15ed6deb6c85e65524a1678c19bf1fe6e0ce" => :mojave
    sha256 "df212ad1e83ca69002400157f5bb69878bfdf7484af8bfab641c80d3deed22db" => :high_sierra
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
