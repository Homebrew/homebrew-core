class Gabo < Formula
  desc "Generates GitHub Actions boilerplate"
  homepage "https://github.com/ashishb/gabo"
  url "https://github.com/ashishb/gabo/archive/refs/tags/v1.7.4.tar.gz"
  sha256 "00d8b1aa07903d332ea975c0ca7d51b994d6de24c8040180420d97d6617b3735"
  license "Apache-2.0"
  head "https://github.com/ashishb/gabo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6cc0e3b223c52e1dfaf1f870ec503de90af117f5eab6257936ce20b7fce783a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6cc0e3b223c52e1dfaf1f870ec503de90af117f5eab6257936ce20b7fce783a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6cc0e3b223c52e1dfaf1f870ec503de90af117f5eab6257936ce20b7fce783a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "e007346058969d960c25813bf9839b7566861fd7c226c054672286c6906b5a05"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dad4472e05ce112acdb4d1a440a52c5154ab9595c14509e9265e6c3bb48c1870"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34a7285ac70de59019ff8d46f5f398133f86d2a72751c6420213f576770b43f9"
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
