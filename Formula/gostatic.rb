class Gostatic < Formula
  desc "Fast static site generator"
  homepage "https://github.com/piranha/gostatic"
  url "https://github.com/piranha/gostatic/archive/2.25.tar.gz"
  sha256 "141ce5fa62841263557569d527989a0df2bdd83c6bc0b5e3c499a752a5e3c962"
  license "ISC"
  head "https://github.com/piranha/gostatic.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "98866a0b91a8bc0d9499e2fe3d8215d79a674cfdc11089fa5feae15b9797383e" => :big_sur
    sha256 "b6855226c3c819d8c567bd08cb7d98dd9a2509f09901fc11066614ca2552e349" => :arm64_big_sur
    sha256 "70cf99943af6cc808131048373a9afe23dcc31168ac720aeafca93dc9cdde423" => :catalina
    sha256 "185fae96275a567bf4639cdca30cdc1317201411426617cd64c6f4148b2c7edf" => :mojave
    sha256 "214241a4f6f57038167698e306a7fa2b8584c494da162b848c90210ffb11170c" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w"
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
