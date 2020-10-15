class Gostatic < Formula
  desc "Fast static site generator"
  homepage "https://github.com/piranha/gostatic"
  url "https://github.com/piranha/gostatic/archive/2.24.tar.gz"
  sha256 "efeb4bf279122e4afb9c448193143fff7eb2bdb4373dcc248bd9746ad29b9a7f"
  license "ISC"
  head "https://github.com/piranha/gostatic.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "70cf99943af6cc808131048373a9afe23dcc31168ac720aeafca93dc9cdde423" => :catalina
    sha256 "185fae96275a567bf4639cdca30cdc1317201411426617cd64c6f4148b2c7edf" => :mojave
    sha256 "214241a4f6f57038167698e306a7fa2b8584c494da162b848c90210ffb11170c" => :high_sierra
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
