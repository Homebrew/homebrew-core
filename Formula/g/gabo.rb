class Gabo < Formula
  desc "Generates GitHub Actions boilerplate"
  homepage "https://ashishb.net/tech/common-pitfalls-of-github-actions/"
  url "https://github.com/ashishb/gabo/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "c3aa5177f3d2023d37da0e6266d67c38a1a8f8eb3f7f51567ade159306bc0711"
  license "Apache-2.0"
  head "https://github.com/ashishb/gabo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bcaa3bc3a2de06891dd268ef7094052e53e4ef007be877d61c1c35828f895a33"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bcaa3bc3a2de06891dd268ef7094052e53e4ef007be877d61c1c35828f895a33"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bcaa3bc3a2de06891dd268ef7094052e53e4ef007be877d61c1c35828f895a33"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca9c88cb8c34d035eb6960e6bf32a3555b9a701a0aa800741dc1747e8dd78713"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ad9646ef9a1223e2c702320cf5f2f93c605572fbe8940fd54e60d5f541629d9"
    sha256 cellar: :any,                 x86_64_linux:  "22ec5b448bb51383f81483b0f3d0a550da862c810d218fa9efd697f6a55d748d"
  end

  depends_on "go" => :build

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
