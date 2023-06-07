class Gostatic < Formula
  desc "Fast static site generator"
  homepage "https://github.com/piranha/gostatic"
  url "https://github.com/piranha/gostatic/archive/2.36.tar.gz"
  sha256 "a66e306c0289bac541af10cb88acc9b9576153de5d4acec566c3f927acefd778"
  license "ISC"
  head "https://github.com/piranha/gostatic.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fee49b6f3e2a28ea13f71e318c63fdccfbfeea301290623c741602b4ba7efa42"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fee49b6f3e2a28ea13f71e318c63fdccfbfeea301290623c741602b4ba7efa42"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fee49b6f3e2a28ea13f71e318c63fdccfbfeea301290623c741602b4ba7efa42"
    sha256 cellar: :any_skip_relocation, ventura:        "702b45e745c213901ee9bac69898a39fca340055bea4257ed12967563990d842"
    sha256 cellar: :any_skip_relocation, monterey:       "702b45e745c213901ee9bac69898a39fca340055bea4257ed12967563990d842"
    sha256 cellar: :any_skip_relocation, big_sur:        "702b45e745c213901ee9bac69898a39fca340055bea4257ed12967563990d842"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3fc806119828adc0ed8433ff0dfdb9573f76bac686ffa19d368726d978d7aacb"
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
