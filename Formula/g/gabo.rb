class Gabo < Formula
  desc "Generates GitHub Actions boilerplate"
  homepage "https://github.com/ashishb/gabo"
  url "https://github.com/ashishb/gabo/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "2455adfd676d71ddcbd27671368a7efe1b459137a8aa69cbbeb0158582f9f5dd"
  license "Apache-2.0"
  head "https://github.com/ashishb/gabo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5df65bd5c044d902fa89ac2f9201b4c7160f9753f25bf81001e642bad88c9a77"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5df65bd5c044d902fa89ac2f9201b4c7160f9753f25bf81001e642bad88c9a77"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5df65bd5c044d902fa89ac2f9201b4c7160f9753f25bf81001e642bad88c9a77"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ad2e4983ffc4014cc1c7d270eae9eb060c7612fa320e02c67e64dccef3abdad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2cb01e1336209bde963052af1a741731597a504c06c0a8bcf60adf8652228555"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b9044657bae3e7532368efda285fe5863fade69d51eb28b232ccf12b7fe8f85"
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
