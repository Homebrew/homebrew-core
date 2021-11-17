class Gostatic < Formula
  desc "Fast static site generator"
  homepage "https://github.com/piranha/gostatic"
  url "https://github.com/piranha/gostatic/archive/2.32.tar.gz"
  sha256 "857de1667660e71f890de019a230ce6c0ab5fdb2420511c4cf74d5f73a5a224a"
  license "ISC"
  head "https://github.com/piranha/gostatic.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9aad98ab7d7c5886f7cddebe62ca2ae9d2b4cf8c03af5224f562fb2883fbd0c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b28048be6882dd7cfbe190c3183be073f008a4ac54463319282bffd789237e0c"
    sha256 cellar: :any_skip_relocation, monterey:       "611af2795147728139cb7f9a4a1d784cc43b05e26d46a1e65ad80f07e577f03b"
    sha256 cellar: :any_skip_relocation, big_sur:        "ebfca024745bdf8c11c37fc95a5a8aa21afa43cb6c4f98c5a86f38a552eca441"
    sha256 cellar: :any_skip_relocation, catalina:       "bf67351bb1dfc59407dd8e51ced98d6c8982c04d2fa6118391690743e721f1ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2f8b38145cd9361420e36e7c02586fc261de6a37c534ff06e871413715032ca"
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
