class Gabo < Formula
  desc "Generates GitHub Actions boilerplate"
  homepage "https://ashishb.net/tech/common-pitfalls-of-github-actions/"
  url "https://github.com/ashishb/gabo/archive/refs/tags/v1.25.0.tar.gz"
  sha256 "9a009a74007433645abe0171e5f50aba73317b1bb9991c2de519557eb3ee4028"
  license "Apache-2.0"
  head "https://github.com/ashishb/gabo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c4663b71639a9896f6df33ad865ddf7147df1112bdefadc49641cbee64e2693d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c4663b71639a9896f6df33ad865ddf7147df1112bdefadc49641cbee64e2693d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c4663b71639a9896f6df33ad865ddf7147df1112bdefadc49641cbee64e2693d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6cdfa0ad0b45f3a998ba982a6f063dc374183ff82f8cde080ecc70bf93c66afa"
    sha256 cellar: :any,                 x86_64_linux:      "dbde905c7fbde7a782b7d1bd375f150bab8f2271f089487bf3f0e6f89956b154"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download", "-C", "src/gabo"
  end

  def install
    cd "src/gabo" do
      system "go", "build", *std_go_args, "./cmd/gabo"
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
