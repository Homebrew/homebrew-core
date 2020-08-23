class Gostatic < Formula
  desc "Fast static site generator"
  homepage "https://github.com/piranha/gostatic"
  url "https://github.com/piranha/gostatic/archive/2.21.tar.gz"
  sha256 "5749c03d7854cb6479ad765993cb032ad04675d18f92c1f55566b1bb2146f6a2"
  license "ISC"
  head "https://github.com/piranha/gostatic.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9442534f628490c837ad638025a327654fbe9ea32181ac282fb50e375833b8a7" => :catalina
    sha256 "d9ccf0db837ffdec144e6d0e96b3bd0b00ec5862f99b378a39d32befa52da708" => :mojave
    sha256 "bacddb091bd43d5ed7d4d0fce06fbceb79bdbcbfbaf44134eff09731de835490" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
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
