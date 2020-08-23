class Gostatic < Formula
  desc "Fast static site generator"
  homepage "https://github.com/piranha/gostatic"
  url "https://github.com/piranha/gostatic/archive/2.22.tar.gz"
  sha256 "df32e6cd145c7e20c7b0e64aecfcca5f3c4c76a672d396e432d62e6814b3e306"
  license "ISC"
  head "https://github.com/piranha/gostatic.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "97751a617808925424f60170c9e374d10281b1207d216ca023e7b53b4b478d83" => :catalina
    sha256 "11c508db4cfa065cabcfba271bb0645613edd7d769c936e53dae397627227a3b" => :mojave
    sha256 "837b41d0db64e687af41d35b84c7c0f48fb421cac8999a83264b38cf71c6aaf5" => :high_sierra
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
