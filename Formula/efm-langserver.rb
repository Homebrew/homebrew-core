class EfmLangserver < Formula
  desc "General purpose Language Server"
  homepage "https://github.com/mattn/efm-langserver"
  url "https://github.com/mattn/efm-langserver.git",
      tag:      "v0.0.37",
      revision: "9c36ed86c653501ec965f92f1c3d2bdb9752d0e3"
  license "MIT"
  head "https://github.com/mattn/efm-langserver.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "418638ff3b4e9f6f5800719bb5130a70679609a35e5da10b6a68111ff2ad591b"
    sha256 cellar: :any_skip_relocation, big_sur:       "da29b8929385cbfe05b8adcdb14464788dc9e478769c27bef8e1ec61b67ad47c"
    sha256 cellar: :any_skip_relocation, catalina:      "da29b8929385cbfe05b8adcdb14464788dc9e478769c27bef8e1ec61b67ad47c"
    sha256 cellar: :any_skip_relocation, mojave:        "da29b8929385cbfe05b8adcdb14464788dc9e478769c27bef8e1ec61b67ad47c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f81fa27a7d119198656901efedf30030a56c52f2b4b7483193e7adbcb39a31c8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    (testpath/"config.yml").write <<~EOS
      version: 2
      root-markers:
        - ".git/"
      languages:
        python:
          - lint-command: "flake8 --stdin-display-name ${INPUT} -"
            lint-stdin: true
    EOS
    output = shell_output("#{bin}/efm-langserver -c #{testpath/"config.yml"} -d")
    assert_match "version: 2", output
    assert_match "lint-command: flake8 --stdin-display-name ${INPUT} -", output
  end
end
