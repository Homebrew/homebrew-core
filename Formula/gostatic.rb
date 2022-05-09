class Gostatic < Formula
  desc "Fast static site generator"
  homepage "https://github.com/piranha/gostatic"
  url "https://github.com/piranha/gostatic/archive/2.34.tar.gz"
  sha256 "fc61c77e76e81b17b9955d18341da3f62e2f8def6a8f33156681e046ab1e80c5"
  license "ISC"
  head "https://github.com/piranha/gostatic.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f44df8fbf9a4a937087fa255aea21c78f086cb2343aae067a73a6383f818495c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "07506614b233d6e61e02326c934d758a9eb456f037edc9f307248e916d2dcd94"
    sha256 cellar: :any_skip_relocation, monterey:       "e217668f8086ac3185f1c23d594317d680ad7bca9fb97af75531ffbe8d299853"
    sha256 cellar: :any_skip_relocation, big_sur:        "845e306d8fc02a1cc8c5328789560f57d0d0df313c65a275037e0e84e9491c99"
    sha256 cellar: :any_skip_relocation, catalina:       "03de028c202e88cc7b5f4661b54403c205fe75259f0f34fe3764f4416dc98a82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "283240692aa393ce727bbdfb5d9cf7ce7dfea49da0cd70333a802066378e85ce"
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
