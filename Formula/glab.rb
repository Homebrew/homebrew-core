class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://glab.readthedocs.io/"
  url "https://github.com/profclems/glab/archive/v1.20.0.tar.gz"
  sha256 "c0b5644f53e5d66b77843c4e1f5746fed12f31079fc95679ac78d05609a87e65"
  license "MIT"
  head "https://github.com/profclems/glab.git", branch: "trunk"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c37212705c5790ed60ccdfd75e8113fba4cf374ce16e7773e3778ecf3d0ab63d"
    sha256 cellar: :any_skip_relocation, big_sur:       "e0868a98a06b3d35d5f04804e824887b6b75372994f65e1d53f39d7575e91d08"
    sha256 cellar: :any_skip_relocation, catalina:      "b3cc62044edc1c0556c22952ad806246d3b9d662bcf2462c03c90f9d0e0b6d6c"
    sha256 cellar: :any_skip_relocation, mojave:        "bc4d1610146aff1867df1c099eb8d546eab62f600918af6a5c3a7674d8f7c274"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5cf350e914ae5cbb9c2c7c74b8b5843dd9427a0c0658127e6065dbab7309d55"
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
