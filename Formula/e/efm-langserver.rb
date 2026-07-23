class EfmLangserver < Formula
  desc "General purpose Language Server"
  homepage "https://github.com/mattn/efm-langserver"
  url "https://github.com/mattn/efm-langserver/archive/refs/tags/v0.0.57.tar.gz"
  sha256 "5a00742ab59c146514f652cc1d8cd34df1b0b1c692706261e4a97131f9cbe935"
  license "MIT"
  head "https://github.com/mattn/efm-langserver.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "50f2d3c5317f906f0192807134b7da4128d0d12a2fe69c211de71738b8621335"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50f2d3c5317f906f0192807134b7da4128d0d12a2fe69c211de71738b8621335"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50f2d3c5317f906f0192807134b7da4128d0d12a2fe69c211de71738b8621335"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd0c15802dd89baa6491c0fbd774d95b022e220acda7fe2003ec227bce0db9c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4d9da4e82f10be21cce2b868aaabbe9174c06c38602ba855de66b766ee41b4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e22442ad63b6563049330d758fa196c66e70dfd6f538193a21c0f92bb8b194f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"config.yml").write <<~YAML
      version: 2
      root-markers:
        - ".git/"
      languages:
        python:
          - lint-command: "flake8 --stdin-display-name ${INPUT} -"
            lint-stdin: true
    YAML
    output = shell_output("#{bin}/efm-langserver -c #{testpath/"config.yml"} -d")
    assert_match "version: 2", output
    assert_match "lint-command: flake8 --stdin-display-name ${INPUT} -", output
  end
end
