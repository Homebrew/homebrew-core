class Aptly < Formula
  desc "Swiss army knife for Debian repository management"
  homepage "https://www.aptly.info/"
  url "https://github.com/smira/aptly/archive/v1.1.0.tar.gz"
  sha256 "83528171ea0cb6f84c759fb5beaa5de85f845bf34d5c9a995c3d4c543c639be5"
  head "https://github.com/smira/aptly.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "39483b7e222a9d683b09963316a45542b1ec0feda960ba0fe2bc316c0df07f80" => :sierra
    sha256 "2d114bfb81310b2af4eca98373d3bcfbac529dc7beef44b18ca7bfe3e585811c" => :el_capitan
    sha256 "952bdf9c5dd8fb93e77ee2281425f11481d8633a1fb5a836e5cef5a188bdc42e" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = bin
    (buildpath/"src/github.com/smira/aptly").install buildpath.children
    cd "src/github.com/smira/aptly" do
      system "make", "VERSION=#{version}", "install"
      prefix.install_metafiles
    end
  end

  test do
    assert_match "aptly version:", shell_output("#{bin}/aptly version")
    (testpath/".aptly.conf").write("{}")
    result = shell_output("#{bin}/aptly -config='#{testpath}/.aptly.conf' mirror list")
    assert_match "No mirrors found, create one with", result
  end
end
