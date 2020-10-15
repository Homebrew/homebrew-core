class Mage < Formula
  desc "Make/rake-like build tool using Go"
  homepage "https://magefile.org"
  url "https://github.com/magefile/mage.git",
      tag:      "v1.10.0",
      revision: "9a10961401323a8a888d46e35d5a59d7433e092b"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "515be0f1647600a652fb18c7ca2eae45683e9e22f22ef7a8cfa0257e05ef6024" => :catalina
    sha256 "d785e2a6fb3cb2a03db1a83ea1f5f2105b6dd0b254d868b7b8950ceb8910c97a" => :mojave
    sha256 "743f8a5be5aa6dc79dbbd7f44b5cfe1726862c865042d22183d522c863994e7f" => :high_sierra
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
