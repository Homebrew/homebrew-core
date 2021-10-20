class Gostatic < Formula
  desc "Fast static site generator"
  homepage "https://github.com/piranha/gostatic"
  url "https://github.com/piranha/gostatic/archive/2.30.tar.gz"
  sha256 "652595f364436833792501f31de36f0cd4fe27f50f4ea0009bfae83c9e518ebb"
  license "ISC"
  head "https://github.com/piranha/gostatic.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1ecdb8c14c707eb0f7dc42796c07ffa5303b1f687c3bbfc6924d8b9506b8655f"
    sha256 cellar: :any_skip_relocation, big_sur:       "b1b74b8e646a07562fb4201215a55cdca9975d189b669b0a1a92ddd5915c9bf7"
    sha256 cellar: :any_skip_relocation, catalina:      "4db3ec282a190b3fe7b79f37cce04dd5b9913924a1c539563c5ee42b89c480c4"
    sha256 cellar: :any_skip_relocation, mojave:        "0bf75b7c812f2ef9bf9ecd78ea2d74c5fbb93bb7edf8502a796271fe312c21ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "489dcb53c5a2e1f96136a17602b91b3223428b3099a94123d577f7c4198b09be"
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
