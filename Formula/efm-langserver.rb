class EfmLangserver < Formula
  desc "General purpose Language Server"
  homepage "https://github.com/mattn/efm-langserver"
  url "https://github.com/mattn/efm-langserver/archive/v0.0.41.tar.gz"
  sha256 "b997e288af9efeb389a188e78867815494137bcbb24fc864eaaa39abecad540e"
  license "MIT"
  head "https://github.com/mattn/efm-langserver.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dfccc2d0447da550b2ef7cddc6cd896eca75960b4e15713439565c3ae71da9d3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dfccc2d0447da550b2ef7cddc6cd896eca75960b4e15713439565c3ae71da9d3"
    sha256 cellar: :any_skip_relocation, monterey:       "40d4b8ccb48cceff6b2cd6bab59776258131b68aaed1718163ecf3190913b37b"
    sha256 cellar: :any_skip_relocation, big_sur:        "40d4b8ccb48cceff6b2cd6bab59776258131b68aaed1718163ecf3190913b37b"
    sha256 cellar: :any_skip_relocation, catalina:       "40d4b8ccb48cceff6b2cd6bab59776258131b68aaed1718163ecf3190913b37b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f35dde14b04e3777107eb72e2ea7e93d3854b9cba06c2281e440a5d1e30c377f"
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
