class Mage < Formula
  desc "Make/rake-like build tool using Go"
  homepage "https://magefile.org"
  url "https://github.com/magefile/mage.git",
      :tag      => "v1.9.0",
      :revision => "1c36bf78a98209d91af71354deb001cca75e11fc"
  sha256 "e8fdfa30f68c8a90fcadd4e82f49c9136011accabff55e073ea26f5ee4280cf0"

  bottle do
    cellar :any_skip_relocation
    sha256 "8833b1072a45cee90428727a5d12f535ea47c88fad1af229404b9e928eed885b" => :mojave
    sha256 "25e0320d8267416873745b7236ea3744a845e88e42a802039d4d43acc8d29a26" => :high_sierra
    sha256 "830b0ba9dcfd80c1d10ce587ceafb9585f4d98cb072dc30107ca34958f0858af" => :sierra
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
