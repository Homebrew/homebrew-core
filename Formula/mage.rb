class Mage < Formula
  desc "Make/rake-like build tool using Go"
  homepage "https://magefile.org"
  url "https://github.com/magefile/mage.git",
      :tag      => "v1.8.0",
      :revision => "aedfce64c122eef47009b7f80c9771044753215d"
  sha256 "e8fdfa30f68c8a90fcadd4e82f49c9136011accabff55e073ea26f5ee4280cf0"

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
