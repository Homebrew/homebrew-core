class EfmLangserver < Formula
  desc "General purpose Language Server"
  homepage "https://github.com/mattn/efm-langserver"
  url "https://github.com/mattn/efm-langserver/archive/v0.0.38.tar.gz"
  sha256 "989cdc330f8a3141d019949830fb83952ce426c679ffcd6d41bfe29022134609"
  license "MIT"
  head "https://github.com/mattn/efm-langserver.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44989b027cf13ce82762a9cd41f28088885bcee883d01a7813ad861b8a733243"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "44989b027cf13ce82762a9cd41f28088885bcee883d01a7813ad861b8a733243"
    sha256 cellar: :any_skip_relocation, monterey:       "7278ffb0b3bf49ef69e7d261c1b105116311c135afbfb691c0ac73d2b8582956"
    sha256 cellar: :any_skip_relocation, big_sur:        "7278ffb0b3bf49ef69e7d261c1b105116311c135afbfb691c0ac73d2b8582956"
    sha256 cellar: :any_skip_relocation, catalina:       "7278ffb0b3bf49ef69e7d261c1b105116311c135afbfb691c0ac73d2b8582956"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7f90427531a6bd50d857d12aaee106f49723933ff54c23a6395b28879f9dbed"
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
