class Gabo < Formula
  desc "Generates GitHub Actions boilerplate"
  homepage "https://github.com/ashishb/gabo"
  url "https://github.com/ashishb/gabo/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "f0f3b926d6e7a6381ceb2fb4ef0d18d51dd5c925f1e7c2577105e0ef7614bb5b"
  license "Apache-2.0"
  head "https://github.com/ashishb/gabo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d111a3b7f14da8628a036090a88ba1f45a02f13a2806ce30cc032e08dc7aa0a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d111a3b7f14da8628a036090a88ba1f45a02f13a2806ce30cc032e08dc7aa0a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d111a3b7f14da8628a036090a88ba1f45a02f13a2806ce30cc032e08dc7aa0a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "208c2e27d954884e1ee019e5b85fa11dee4dd31ef284e0223c7e99f02d54aaee"
    sha256 cellar: :any_skip_relocation, ventura:       "208c2e27d954884e1ee019e5b85fa11dee4dd31ef284e0223c7e99f02d54aaee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7a12de57069cc5db5fb5017606d7c9ff1f2b181b35f49bd8dbc6431e2ff80c0"
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
