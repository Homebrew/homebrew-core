class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://glab.readthedocs.io/"
  url "https://github.com/profclems/glab/archive/v1.19.0.tar.gz"
  sha256 "693fa7d81e50a1a029eec94b0d1a779f2627d17a4a73d4d40d833242a3ff7b1b"
  license "MIT"
  head "https://github.com/profclems/glab.git", branch: "trunk"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b3053ed3b503f358326ee09ece85d31b6659835e7b35c23eb5e5e2e62e0a491a"
    sha256 cellar: :any_skip_relocation, big_sur:       "9a2f3821984bc6c24571cc7461be8f84cea8bfaecc78f5900ba34bc2b33e8397"
    sha256 cellar: :any_skip_relocation, catalina:      "c48bbd22fc04d942edc8b0041bbdaf3c095c040d47a33f4f1223da67341f867f"
    sha256 cellar: :any_skip_relocation, mojave:        "737ba02ba0bf3fb7c6f126b87cf0d3b265b22ba2c282f4ae582b3d2139341720"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b06c843e78d16a71e25dbc6118f1688138722a34f3181a841b967b1da93ab05"
  end

  depends_on "go" => :build

  def install
    on_macos { ENV["CGO_ENABLED"] = "1" }

    system "make", "GLAB_VERSION=#{version}"
    bin.install "bin/glab"
    (bash_completion/"glab").write Utils.safe_popen_read(bin/"glab", "completion", "--shell=bash")
    (zsh_completion/"_glab").write Utils.safe_popen_read(bin/"glab", "completion", "--shell=zsh")
    (fish_completion/"glab.fish").write Utils.safe_popen_read(bin/"glab", "completion", "--shell=fish")
  end

  test do
    system "git", "clone", "https://gitlab.com/profclems/test.git"
    cd "test" do
      assert_match "Clement Sam", shell_output("#{bin}/glab repo contributors")
      assert_match "This is a test issue", shell_output("#{bin}/glab issue list --all")
    end
  end
end
