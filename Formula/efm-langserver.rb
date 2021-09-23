class EfmLangserver < Formula
  desc "General purpose Language Server"
  homepage "https://github.com/mattn/efm-langserver"
  url "https://github.com/mattn/efm-langserver/archive/v0.0.37.tar.gz"
  sha256 "6c175b3baa7934e34898a90197397d3aed2827ceeb00fd4eb9ff03bddb3cf565"
  license "MIT"
  head "https://github.com/mattn/efm-langserver.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6ef394cfe93aeeec10c28594472509b78c39429fdb5f8df0ad920d7f46a38582"
    sha256 cellar: :any_skip_relocation, big_sur:       "b9a805baeac648cfe331aad089ba6a6f5580c60277adb656d3a834039a89cdd2"
    sha256 cellar: :any_skip_relocation, catalina:      "b9a805baeac648cfe331aad089ba6a6f5580c60277adb656d3a834039a89cdd2"
    sha256 cellar: :any_skip_relocation, mojave:        "b9a805baeac648cfe331aad089ba6a6f5580c60277adb656d3a834039a89cdd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9de97af411635b491006fbc55bf7dc805b92617f8a38749c90791f5abb2671e7"
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
