class EfmLangserver < Formula
  desc "General purpose Language Server"
  homepage "https://github.com/mattn/efm-langserver"
  url "https://github.com/mattn/efm-langserver.git",
    tag:      "v0.0.30",
    revision: "0e684cd869c2d3aa8e4dd0e680ebf5f006cb63e5"
  license "MIT"
  head "https://github.com/mattn/efm-langserver.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ecead6cf10d440629d7825c2fcde0e526f9ffbb26bc841e6ade39fd5d09e9e46"
    sha256 cellar: :any_skip_relocation, big_sur:       "551b11269c5e5a8271939c968b8819326f42bd54012eed58ab5e7f0a3d06eb45"
    sha256 cellar: :any_skip_relocation, catalina:      "551b11269c5e5a8271939c968b8819326f42bd54012eed58ab5e7f0a3d06eb45"
    sha256 cellar: :any_skip_relocation, mojave:        "551b11269c5e5a8271939c968b8819326f42bd54012eed58ab5e7f0a3d06eb45"
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
