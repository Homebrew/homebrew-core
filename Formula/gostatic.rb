class Gostatic < Formula
  desc "Fast static site generator"
  homepage "https://github.com/piranha/gostatic"
  url "https://github.com/piranha/gostatic/archive/2.36.tar.gz"
  sha256 "a66e306c0289bac541af10cb88acc9b9576153de5d4acec566c3f927acefd778"
  license "ISC"
  head "https://github.com/piranha/gostatic.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "641956d41c41c109be89e1604335326c594c785f048e7fb370c76a2f3e1485e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "afe3444a665ab170ac05f57af7b21bc2f0ef67728030eda826a29b4cd263bf73"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "51a4d75756fdd90bfca110b7419885f6edd5d957dd1e1dd9695eaddbee695341"
    sha256 cellar: :any_skip_relocation, ventura:        "ee79c147e2d795bc492285ef9d18cb5113bd4b571fa82102857ae5b74edf05c6"
    sha256 cellar: :any_skip_relocation, monterey:       "499cd482d6bf9f5a66d41757180fd98da349c4305b64c9f269be5307625c7e85"
    sha256 cellar: :any_skip_relocation, big_sur:        "528bc2fa866ed10403f9af17b0dec443bd212392cce97d3f25df0f8be3b4ecf4"
    sha256 cellar: :any_skip_relocation, catalina:       "24345e0269c9d66290e29413b88e800e5df1a4a4a9b144a0a83bb9a6c9a70b74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "763f6313a738d1fb1a20175effd345089978ee5c8a3cba15c749dc700c7e57f1"
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
