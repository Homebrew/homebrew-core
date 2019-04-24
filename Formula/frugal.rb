class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/3.3.1.tar.gz"
  sha256 "2603c264a83bc8a93fc19ea78fceddbfc2a2808ea73056b7aa676f74a91de095"

  bottle do
    cellar :any_skip_relocation
    sha256 "a74917b7d8dfacdf362d84e77ebed45133c5ec60326bf7343f2ddc7c1c7d887b" => :mojave
    sha256 "387d228b3da35ab3585696ebe690489903f5ff9d182bdd04f18ffbcc19a6aa30" => :high_sierra
    sha256 "598847ee5457b77a9213d3322896072e802dbe884eb155646bffdb57169bf3ef" => :sierra
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
