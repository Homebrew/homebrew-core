class Gostatic < Formula
  desc "Fast static site generator"
  homepage "https://github.com/piranha/gostatic"
  url "https://github.com/piranha/gostatic/archive/2.34.tar.gz"
  sha256 "fc61c77e76e81b17b9955d18341da3f62e2f8def6a8f33156681e046ab1e80c5"
  license "ISC"
  head "https://github.com/piranha/gostatic.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4daa04700da1032af0a162412f3c9c853ba1c2044daef8169fbbd55eae60fe46"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5ea61a4050fccf533069aefa065611beedf2d43438fcf6d5eacb0df0789271a4"
    sha256 cellar: :any_skip_relocation, monterey:       "716362ef77b40110d1ae1613613b67d51a985c84c567fefd0e759ac5c7d168bb"
    sha256 cellar: :any_skip_relocation, big_sur:        "8493519376ae8512fb5e2d4c83481c27e964bb63c854c1aa14f15d0494311fa3"
    sha256 cellar: :any_skip_relocation, catalina:       "01d319962c9ad1c3f5955ceaeadf4286944d33e82d90b44d36a0f4bec37089d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce5a780002a737100f543ff761ae7c8bdff06de65e0f0931ceb931061d740f61"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"config").write <<~EOS
      TEMPLATES = site.tmpl
      SOURCE = src
      OUTPUT = out
      TITLE = Hello from Homebrew

      index.md:
      \tconfig
      \text .html
      \tmarkdown
      \ttemplate site
    EOS

    (testpath/"site.tmpl").write <<~EOS
      {{ define "site" }}
      <html><head><title>{{ .Title }}</title></head><body>{{ .Content }}</body></html>
      {{ end }}
    EOS

    (testpath/"src/index.md").write "Hello world!"

    system bin/"gostatic", testpath/"config"
    assert_predicate testpath/"out/index.html", :exist?
  end
end
