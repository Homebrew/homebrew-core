class EfmLangserver < Formula
  desc "General purpose Language Server"
  homepage "https://github.com/mattn/efm-langserver"
  url "https://github.com/mattn/efm-langserver.git",
    tag:      "v0.0.35",
    revision: "e1a26e01fafef41a950497cd0d85ae5dcd8f0d0e"
  license "MIT"
  head "https://github.com/mattn/efm-langserver.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bd68f0f61a26fd9ad8d1f992c8013c3df79d6097a3314f133f8fc63fdade8997"
    sha256 cellar: :any_skip_relocation, big_sur:       "2cb2b42f427eee054d89f9e12714524d52091763c6c5171a4195ccd7a1a0ed70"
    sha256 cellar: :any_skip_relocation, catalina:      "2cb2b42f427eee054d89f9e12714524d52091763c6c5171a4195ccd7a1a0ed70"
    sha256 cellar: :any_skip_relocation, mojave:        "2cb2b42f427eee054d89f9e12714524d52091763c6c5171a4195ccd7a1a0ed70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e133adbe3da135681890ebe868bd87acaf1e529cbeef1ac4e4d90516267ac358"
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
