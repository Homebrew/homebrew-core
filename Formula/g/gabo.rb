class Gabo < Formula
  desc "Generates GitHub Actions boilerplate"
  homepage "https://github.com/ashishb/gabo"
  url "https://github.com/ashishb/gabo/archive/refs/tags/v1.6.4.tar.gz"
  sha256 "ef499e3da87e0ea55897ce9ff914086d2a904bec873838c9132b4122912b98bc"
  license "Apache-2.0"
  head "https://github.com/ashishb/gabo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "29d5b6a323bd621d561cf288f7fec6816ecf36545f8f1cc8f1e3820e4c134be8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29d5b6a323bd621d561cf288f7fec6816ecf36545f8f1cc8f1e3820e4c134be8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29d5b6a323bd621d561cf288f7fec6816ecf36545f8f1cc8f1e3820e4c134be8"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed853bfb584e3b303403e5204a4ba53fd8645df43489efd9138be4abebe9ad8d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7cc6ca358060a0dd74afcdd55775baadbed4bfb3c0063789d1643702cde97f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc55b7259909ba2557414d680dcd916463591bf543c551cfacd0cfa7dba86108"
  end

  depends_on "go" => :build

  def install
    cd "src/gabo" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gabo"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gabo --version")

    gabo_test = testpath/"gabo-test"
    gabo_test.mkpath
    (gabo_test/".git").mkpath # Emulate git
    system bin/"gabo", "-dir", gabo_test, "-for", "lint-yaml", "-mode=generate"
    assert_path_exists gabo_test/".github/workflows/lint-yaml.yaml"
  end
end
