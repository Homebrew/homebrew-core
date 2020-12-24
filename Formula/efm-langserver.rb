class EfmLangserver < Formula
  desc "General purpose Language Server"
  homepage "https://github.com/mattn/efm-langserver"
  url "https://github.com/mattn/efm-langserver.git",
    tag:      "v0.0.26",
    revision: "26be4445542b8aa1aa0233a856ade7161644035c"
  license "MIT"
  head "https://github.com/mattn/efm-langserver.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e9897f2c173f23ae85e7c79058787caeeabf83d3665afc726b021667d764732f" => :big_sur
    sha256 "27a983a57a57b18b64f38897a0005eda50b7a242aeb7dd39f50837c53a11530d" => :catalina
    sha256 "13bffac8dfa2c47f2b4f7fa6fd28e1eb4c94c520e3e26eebd275272ef4079da5" => :mojave
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
