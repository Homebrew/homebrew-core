class Gostatic < Formula
  desc "Fast static site generator"
  homepage "https://github.com/piranha/gostatic"
  url "https://github.com/piranha/gostatic/archive/2.31.tar.gz"
  sha256 "a1c41e9992878e9ba5505aac8d09ac7ca6aa339d47e8fed5370a53af4df5e6c1"
  license "ISC"
  head "https://github.com/piranha/gostatic.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36cbfb0d278f1810fe443d39741329d7b7c0dd34aff3729e49470f639144ab1c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "92d635f02d982151beb9a3419e72f7b9f10a70427cf9777710e7fec1a6093536"
    sha256 cellar: :any_skip_relocation, monterey:       "521a194ae06f35a3adc39ecd85657006e4150c46dc1cf9083442a23ca619a915"
    sha256 cellar: :any_skip_relocation, big_sur:        "d5493418b9c455a1078b2de5a12ac2dc3360ea45bf9b59fb9a75c7d7b938fc64"
    sha256 cellar: :any_skip_relocation, catalina:       "7844d8d6439ebac5896d509edcea9aa780cb742d5835a1e035cf0f7a9cdc3387"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c665a466cb65dd10d9db5b4c4ad0b77773836f2df1809112718d4599fa3c8a5"
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
