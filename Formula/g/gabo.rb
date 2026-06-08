class Gabo < Formula
  desc "Generates GitHub Actions boilerplate"
  homepage "https://github.com/ashishb/gabo"
  url "https://github.com/ashishb/gabo/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "87e6bdfdd289dcdec515e3ee778baa2261ce0cb650234854bde16c8972a49398"
  license "Apache-2.0"
  head "https://github.com/ashishb/gabo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "751b7f90c7fb2ee374476f0d1a55b41c18d6dd5029f1c4ca3165cfc59aacd116"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "751b7f90c7fb2ee374476f0d1a55b41c18d6dd5029f1c4ca3165cfc59aacd116"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "751b7f90c7fb2ee374476f0d1a55b41c18d6dd5029f1c4ca3165cfc59aacd116"
    sha256 cellar: :any_skip_relocation, sonoma:        "17205eb1f664a326a30251dbc1af58a3bec7ff04cc24cfc8e323b92e33badb1e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e58f6b478b3129ddddc79a8b9cbfd35fe5ad8ccade3ec90d8665d43e4d5ee35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "926beb551ec8477952e5d4f6446feb0afbc80c8801e588678c95ead1d6e88003"
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
