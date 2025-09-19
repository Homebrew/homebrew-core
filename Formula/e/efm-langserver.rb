class EfmLangserver < Formula
  desc "General purpose Language Server"
  homepage "https://github.com/mattn/efm-langserver"
  url "https://github.com/mattn/efm-langserver/archive/refs/tags/v0.0.54.tar.gz"
  sha256 "4149b2922899ce313a89f60851f6678369253ed542dd65bdc8dd22f3cf1629bb"
  license "MIT"
  head "https://github.com/mattn/efm-langserver.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "57061fc09229dcf958741bac9f8cb35a94fc8979252b642b9f34a7b651dee4cd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3fec389284c49ce09101a88899c580d03ead74e23638a30284d903e3f4e5c8a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3fec389284c49ce09101a88899c580d03ead74e23638a30284d903e3f4e5c8a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3fec389284c49ce09101a88899c580d03ead74e23638a30284d903e3f4e5c8a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a243107e41b7158b42aaef39c118b8ad6b2e321bedbedbbec267cc55ae1cd40"
    sha256 cellar: :any_skip_relocation, ventura:       "1a243107e41b7158b42aaef39c118b8ad6b2e321bedbedbbec267cc55ae1cd40"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "93769ecdecbd00b0b2c0e6bf77397f307aaea3952a6049741ba9f46eefbfada2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84eb67d38a415d8f87456816e0ae24e0c1e000d8836f70ba0d9fa115a423a811"
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
