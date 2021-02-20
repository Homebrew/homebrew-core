class Gostatic < Formula
  desc "Fast static site generator"
  homepage "https://github.com/piranha/gostatic"
  url "https://github.com/piranha/gostatic/archive/2.27.tar.gz"
  sha256 "997f0ff4ef173d64fdcc3aaaaf04c000b51e05301cbde9da07877686f22fd662"
  license "ISC"
  head "https://github.com/piranha/gostatic.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "14c946076f648bda53f61d4729137d7a809e0df290917c06aa3b730dceb8d8db"
    sha256 cellar: :any_skip_relocation, big_sur:       "aa20108a4a32b0ac18f7105cfbea9a664a92defd35cd44a0748d65bd4febadb6"
    sha256 cellar: :any_skip_relocation, catalina:      "2a470262e1520d72d081fbdf434d465c6caddb4fae994cf52c492ebfdc358c89"
    sha256 cellar: :any_skip_relocation, mojave:        "53b86628c74221befb9173a3dd949bcaaac7ebe11d4552c385efcf7501871e99"
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
