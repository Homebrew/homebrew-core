class EfmLangserver < Formula
  desc "General purpose Language Server"
  homepage "https://github.com/mattn/efm-langserver"
  url "https://github.com/mattn/efm-langserver/archive/v0.0.42.tar.gz"
  sha256 "44ef0d86c7a1e9d64f205cbcb69ce242b6ca94d933963ef512747a6d03a553a3"
  license "MIT"
  head "https://github.com/mattn/efm-langserver.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1498e16c1e90f9ae1f0c34c0d0968a25ddb6d5ba35c31d450a015a5a8c806189"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1498e16c1e90f9ae1f0c34c0d0968a25ddb6d5ba35c31d450a015a5a8c806189"
    sha256 cellar: :any_skip_relocation, monterey:       "44d1f5e72a143294a3cef032892c79ddff8e2130ec527d6490720821901ef159"
    sha256 cellar: :any_skip_relocation, big_sur:        "44d1f5e72a143294a3cef032892c79ddff8e2130ec527d6490720821901ef159"
    sha256 cellar: :any_skip_relocation, catalina:       "44d1f5e72a143294a3cef032892c79ddff8e2130ec527d6490720821901ef159"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13790803aedcce1aaccc3c41754bb9e37935906033d2a70ec927fea8626f22fd"
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
