class EfmLangserver < Formula
  desc "General purpose Language Server"
  homepage "https://github.com/mattn/efm-langserver"
  url "https://github.com/mattn/efm-langserver/archive/v0.0.42.tar.gz"
  sha256 "44ef0d86c7a1e9d64f205cbcb69ce242b6ca94d933963ef512747a6d03a553a3"
  license "MIT"
  head "https://github.com/mattn/efm-langserver.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "146707db5b61480b445557cd098073aa4cc324e6fea1a0ad68a54e2149739d31"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "146707db5b61480b445557cd098073aa4cc324e6fea1a0ad68a54e2149739d31"
    sha256 cellar: :any_skip_relocation, monterey:       "289f616424b421a7dac7adc3ab5d13f1657ee9d430986bd8fcfb38e2c867acf7"
    sha256 cellar: :any_skip_relocation, big_sur:        "289f616424b421a7dac7adc3ab5d13f1657ee9d430986bd8fcfb38e2c867acf7"
    sha256 cellar: :any_skip_relocation, catalina:       "289f616424b421a7dac7adc3ab5d13f1657ee9d430986bd8fcfb38e2c867acf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "accc6ba3e5901db880542768f6ef9fd9d594ef902d5eb04660d211b529e1bfcf"
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
