class Gostatic < Formula
  desc "Fast static site generator"
  homepage "https://github.com/piranha/gostatic"
  url "https://github.com/piranha/gostatic/archive/2.26.tar.gz"
  sha256 "9d09ad744aa6130fd3a94e2ba7cbeadaab3078f2f92bab3d1beabdc3757d07b1"
  license "ISC"
  head "https://github.com/piranha/gostatic.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "355771ae8c73f34c0f9a4c305bf235b82da246471502a15dfe7bc151c4688ead"
    sha256 cellar: :any_skip_relocation, big_sur:       "a2773f06d4dc430bf5983f04dd3b70ed9b47835e1eb4de5e0f6a5b090151c4b4"
    sha256 cellar: :any_skip_relocation, catalina:      "194b3e611cf3edeac3fdb92fb29613a032e82c8cf890ffca41e1562108f1c8e3"
    sha256 cellar: :any_skip_relocation, mojave:        "4dc77286ca070bd2417e42e5e37882a0526b5451f14630fe8a1a0a1853a645be"
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
