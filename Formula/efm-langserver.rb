class EfmLangserver < Formula
  desc "General purpose Language Server"
  homepage "https://github.com/mattn/efm-langserver"
  url "https://github.com/mattn/efm-langserver.git",
    tag:      "v0.0.36",
    revision: "bd7191e73e6404c8a714779d1ba7f455e4ab4079"
  license "MIT"
  head "https://github.com/mattn/efm-langserver.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a44e2a3c34b20ce1ed7d6a200deece7b8a3ca277f1146d264ed1f976472324a1"
    sha256 cellar: :any_skip_relocation, big_sur:       "90b7af3842aa9b4ccd943d0b4c4fe0700dfc29a1cf39c14ee184f719051f29de"
    sha256 cellar: :any_skip_relocation, catalina:      "90b7af3842aa9b4ccd943d0b4c4fe0700dfc29a1cf39c14ee184f719051f29de"
    sha256 cellar: :any_skip_relocation, mojave:        "90b7af3842aa9b4ccd943d0b4c4fe0700dfc29a1cf39c14ee184f719051f29de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9d854b6b5260a004caa9fe4942e9fa67e63498ec63c8d97e91250e68ad61ce5"
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
