class Gabo < Formula
  desc "Generates GitHub Actions boilerplate"
  homepage "https://github.com/ashishb/gabo"
  url "https://github.com/ashishb/gabo/archive/refs/tags/v1.6.3.tar.gz"
  sha256 "0c643aa2571e3f1af4ff7ef9fa363bc9cc0ae63255be29b9e671854c07abd014"
  license "Apache-2.0"
  head "https://github.com/ashishb/gabo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0db790dac1e8db2f296d2e201c5b7a4d7906fdf4c4c6b722a98df02e4af416a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6eae5bb00df93c37ad9bffec423585d4675398c07dbd7e0c215a709805ba32c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6eae5bb00df93c37ad9bffec423585d4675398c07dbd7e0c215a709805ba32c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a6eae5bb00df93c37ad9bffec423585d4675398c07dbd7e0c215a709805ba32c"
    sha256 cellar: :any_skip_relocation, sonoma:        "b6f41afa9c2276668ad7373e042e3f3290be19ba1ffe46d164731826ecce75d7"
    sha256 cellar: :any_skip_relocation, ventura:       "b6f41afa9c2276668ad7373e042e3f3290be19ba1ffe46d164731826ecce75d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be2861c64505a797f036ea8021b8fbecd2d950c3a8fcc99515a6c40546eab1a6"
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
