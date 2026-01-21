class Gabo < Formula
  desc "Generates GitHub Actions boilerplate"
  homepage "https://github.com/ashishb/gabo"
  url "https://github.com/ashishb/gabo/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "c9d13c1c70cc5c7d2fadb7e2ac14e82ea5d711714e3c7a143fda6964c3d77dc7"
  license "Apache-2.0"
  head "https://github.com/ashishb/gabo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "163fa8fece5c15505b8cbe4c1b0d7b421d2c5048e7b70bb2725e6444f3547980"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "163fa8fece5c15505b8cbe4c1b0d7b421d2c5048e7b70bb2725e6444f3547980"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "163fa8fece5c15505b8cbe4c1b0d7b421d2c5048e7b70bb2725e6444f3547980"
    sha256 cellar: :any_skip_relocation, sonoma:        "f497b6388e3cb295679face1ea1eb7e56247b1ca600f30d7e005b33878e02022"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6057767bae37f467ef3c479093d69155e32ece8e1187b6384a7b80671b98438"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64de067a396de972aaf6868273a7ac938fc3201d11b673ac40912fcd1a308914"
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
