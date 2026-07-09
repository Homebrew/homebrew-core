class Gabo < Formula
  desc "Generates GitHub Actions boilerplate"
  homepage "https://ashishb.net/tech/common-pitfalls-of-github-actions/"
  url "https://github.com/ashishb/gabo/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "e3266d874e260d43544807334924a8a7fe5dafdf4f24a9c6dc0544b8223aadb9"
  license "Apache-2.0"
  head "https://github.com/ashishb/gabo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e8c11183d9b19c3459d3d55bf9ebf48c6607b261ccef7479bb024ab13005b31a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8c11183d9b19c3459d3d55bf9ebf48c6607b261ccef7479bb024ab13005b31a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8c11183d9b19c3459d3d55bf9ebf48c6607b261ccef7479bb024ab13005b31a"
    sha256 cellar: :any_skip_relocation, sonoma:        "4df5fd4e46fd6b4d643cc0099ac1d98783b7a3d9c1dc7decdd642dac59f653c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16ccd4f165faa19eb68bdfae52bd586a9be356b122d4b4cc83207d5ea6647aec"
    sha256 cellar: :any,                 x86_64_linux:  "3a8d49bc85a985345a401a55e0d3d6794fa29e9159bbd7ce2dc1fce23d04fee3"
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
