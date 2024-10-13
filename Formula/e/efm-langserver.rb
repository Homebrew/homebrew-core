class EfmLangserver < Formula
  desc "General purpose Language Server"
  homepage "https://github.com/mattn/efm-langserver"
  url "https://github.com/mattn/efm-langserver/archive/refs/tags/v0.0.53.tar.gz"
  sha256 "2e315b6c563a994d8f5b3d2d8e5be629628b1f6dc7e4a82d9ea1a5deb8c81be6"
  license "MIT"
  head "https://github.com/mattn/efm-langserver.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "9f2519c8b0bd2c84a34ab41818136152b191813d12d6c79469d8dce1f80f1554"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "acdd9f4c7834504e7e8c5078d64c5c602818cd9e51229cfc23c8c6a507d43eb5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "acdd9f4c7834504e7e8c5078d64c5c602818cd9e51229cfc23c8c6a507d43eb5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "acdd9f4c7834504e7e8c5078d64c5c602818cd9e51229cfc23c8c6a507d43eb5"
    sha256 cellar: :any_skip_relocation, sonoma:         "b614e49df5008158661b2dcdf75a1baacad164372e426dcaee83e244999ce3ba"
    sha256 cellar: :any_skip_relocation, ventura:        "b614e49df5008158661b2dcdf75a1baacad164372e426dcaee83e244999ce3ba"
    sha256 cellar: :any_skip_relocation, monterey:       "b614e49df5008158661b2dcdf75a1baacad164372e426dcaee83e244999ce3ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22b2233ec19c7568d83661cbfd6cb196ef85d64fa74a779ca599399c75c7b081"
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
