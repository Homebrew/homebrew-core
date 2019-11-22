class Mage < Formula
  desc "Make/rake-like build tool using Go"
  homepage "https://magefile.org"
  url "https://github.com/magefile/mage.git",
      :tag      => "v1.9.0",
      :revision => "1c36bf78a98209d91af71354deb001cca75e11fc"
  sha256 "e8fdfa30f68c8a90fcadd4e82f49c9136011accabff55e073ea26f5ee4280cf0"

  bottle do
    cellar :any_skip_relocation
    sha256 "4b908f4975776815efc1fb7e019ecec36a58e597575f1597fad536ad382c6fa3" => :catalina
    sha256 "ac88cd06d100522e8a7af513dd4169706c28f1742dfcf237bf1135836ab045a5" => :mojave
    sha256 "4cd5deec2b988ba21b372214ece919ea3cbb0e5bb7413ce7e372b21d34e3dbb1" => :high_sierra
    sha256 "568bb7334e6f30d467fdd6d136284dbda53e2ad70279e8f22f5ba99feffdbb34" => :sierra
  end

  depends_on "go"

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/magefile/mage").install buildpath.children
    cd "src/github.com/magefile/mage" do
      system "go", "run", "bootstrap.go"
      bin.install buildpath/"bin/mage"
      prefix.install_metafiles
    end
  end

  test do
    assert_match "magefile.go created", shell_output("#{bin}/mage -init 2>&1")
    assert_predicate testpath/"magefile.go", :exist?
  end
end
