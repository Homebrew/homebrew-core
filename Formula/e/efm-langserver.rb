class EfmLangserver < Formula
  desc "General purpose Language Server"
  homepage "https://github.com/mattn/efm-langserver"
  url "https://github.com/mattn/efm-langserver/archive/refs/tags/v0.0.56.tar.gz"
  sha256 "6b2c44c904a0a3c54909688ccebc8ca32bba319abbd7f6a8a26590a6359e4950"
  license "MIT"
  head "https://github.com/mattn/efm-langserver.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba4fff52f0034987c392a947853d93e874376f575c4abbbac224e0a60ca694f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba4fff52f0034987c392a947853d93e874376f575c4abbbac224e0a60ca694f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba4fff52f0034987c392a947853d93e874376f575c4abbbac224e0a60ca694f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "18553b3aabe22c67ca3f5880b51e3072e8c92d5bce83a60267b53b3daee032b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44141d8853b027305d2f7fe25403f841a1df68850375fdb7811c2b48a0b5ff2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4498e74e5258997cef6eca090ee7f75e33f4f8e761c906fda78a407ad871821"
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
