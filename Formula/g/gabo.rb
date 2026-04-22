class Gabo < Formula
  desc "Generates GitHub Actions boilerplate"
  homepage "https://github.com/ashishb/gabo"
  url "https://github.com/ashishb/gabo/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "c3a9ad2c0fa716e755796d0139dde669b840833cd08808cea4cd862fa0d0737e"
  license "Apache-2.0"
  head "https://github.com/ashishb/gabo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fa2a9bed61df3ff61dc1df06d7f3e0cb73743b73e8499fa45399c96c10a39e2c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa2a9bed61df3ff61dc1df06d7f3e0cb73743b73e8499fa45399c96c10a39e2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa2a9bed61df3ff61dc1df06d7f3e0cb73743b73e8499fa45399c96c10a39e2c"
    sha256 cellar: :any_skip_relocation, sonoma:        "932c1e875f533d8c6065d4993160ebfa4eb31cd0b974a4756bd944edee1805d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d88b4f854fdad118ae9d382a9ad4d65b9806eed72fae672d6d7fecb7d120215a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e259a47db011363cffa8978152db22fbe7d1f79b633e27eae76af4ae0e8350a"
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
