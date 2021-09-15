class Gostatic < Formula
  desc "Fast static site generator"
  homepage "https://github.com/piranha/gostatic"
  url "https://github.com/piranha/gostatic/archive/2.29.tar.gz"
  sha256 "63650fae7162d6760819cc2846858a39650aaf6cd50b062e7096d944637afa7f"
  license "ISC"
  head "https://github.com/piranha/gostatic.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3f0953aaa726921242d6616f9e44ab80507ddd66921236d94155da2142e5b492"
    sha256 cellar: :any_skip_relocation, big_sur:       "a1ed202acda77b624a10055dee44ebe6bb617a7ad9296d7ea3f89ed379ae8cb2"
    sha256 cellar: :any_skip_relocation, catalina:      "5038e57b3d269b23b12d0ed68ec03e1d5f87af7268478b8cc599a38fa961d398"
    sha256 cellar: :any_skip_relocation, mojave:        "eb25c05011bb04cda6eaee3f96f78c3e2d03ffd2b82ea6fee51b2cb0376756ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46be35bf3ca780e263d622b580642c319e4080028ab87b851b038a7d498c0eb4"
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
