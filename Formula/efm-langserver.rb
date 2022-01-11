class EfmLangserver < Formula
  desc "General purpose Language Server"
  homepage "https://github.com/mattn/efm-langserver"
  url "https://github.com/mattn/efm-langserver/archive/v0.0.39.tar.gz"
  sha256 "2f333e0ba1451ca731b47b27713c961c8223bf081c5f4addff386a55fccd9fb0"
  license "MIT"
  head "https://github.com/mattn/efm-langserver.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c469fb5ccd1aa3f09096e355f058ce3d2e16f71d3e62099e0985e46f0a8334df"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c469fb5ccd1aa3f09096e355f058ce3d2e16f71d3e62099e0985e46f0a8334df"
    sha256 cellar: :any_skip_relocation, monterey:       "b8920dbbe4ab6bfc638b7aa61026fb343833b4a70c39ebd51ef327e5f9c3f445"
    sha256 cellar: :any_skip_relocation, big_sur:        "b8920dbbe4ab6bfc638b7aa61026fb343833b4a70c39ebd51ef327e5f9c3f445"
    sha256 cellar: :any_skip_relocation, catalina:       "b8920dbbe4ab6bfc638b7aa61026fb343833b4a70c39ebd51ef327e5f9c3f445"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42adf8973e9119aa5e02cc183e3615abe171b7f1bf47d320e13d5107f357c7aa"
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
