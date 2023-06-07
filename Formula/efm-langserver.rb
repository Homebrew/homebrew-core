class EfmLangserver < Formula
  desc "General purpose Language Server"
  homepage "https://github.com/mattn/efm-langserver"
  url "https://github.com/mattn/efm-langserver/archive/v0.0.44.tar.gz"
  sha256 "825aef5815fb6eff656370e9f01fc31f91e5b2ab9d2b1f080881839676020dac"
  license "MIT"
  head "https://github.com/mattn/efm-langserver.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a9e55bdf96be85db69ce12744535a0c9a968da3eb9ef51e0f304b72ccb153a4c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c257f67d5df8212d33a8c49793231877dcd7e0a43c234fd02a1b9f84aa1fc30e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c257f67d5df8212d33a8c49793231877dcd7e0a43c234fd02a1b9f84aa1fc30e"
    sha256 cellar: :any_skip_relocation, ventura:        "ceae65a893a3d73d53547684effb22f4a38bd6baa85dc1cea468afda09d953d1"
    sha256 cellar: :any_skip_relocation, monterey:       "82449e9d9af5148a61134aeaf166ecaba6709d3cf797f66a397d1b2e908f7980"
    sha256 cellar: :any_skip_relocation, big_sur:        "82449e9d9af5148a61134aeaf166ecaba6709d3cf797f66a397d1b2e908f7980"
    sha256 cellar: :any_skip_relocation, catalina:       "82449e9d9af5148a61134aeaf166ecaba6709d3cf797f66a397d1b2e908f7980"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1fc00f5f8e752a876c4933c4b0a5c5a402b44964c7292dca4764a55bc703979a"
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
