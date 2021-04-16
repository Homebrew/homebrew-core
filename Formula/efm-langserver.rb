class EfmLangserver < Formula
  desc "General purpose Language Server"
  homepage "https://github.com/mattn/efm-langserver"
  url "https://github.com/mattn/efm-langserver.git",
    tag:      "v0.0.29",
    revision: "f8f1e70e444c3848b6fb32fa871ffdd560456dcf"
  license "MIT"
  head "https://github.com/mattn/efm-langserver.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f479d3e11d8913149766f25d0304f1c3a27cf9bc4404f013bab6ecf51f83107a"
    sha256 cellar: :any_skip_relocation, big_sur:       "9cc00484595c15ab434744dd4680a4eb5aecbce75ec408eb4def459564fcf2d1"
    sha256 cellar: :any_skip_relocation, catalina:      "e8b58845555b6bbe9df05d42e71b6c86d5f2a904da930587876130a76b66abaa"
    sha256 cellar: :any_skip_relocation, mojave:        "b96bad4c290b752b5431e3d9e18f942b2730a8ca38ddedb09a29842556c0d5b6"
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
