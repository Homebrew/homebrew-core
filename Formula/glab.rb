class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://glab.readthedocs.io/"
  url "https://github.com/profclems/glab/archive/v1.21.1.tar.gz"
  sha256 "878c13d064ca6010437de90ca3711962fd87441fcae39bf01cb0af5aa5efd79e"
  license "MIT"
  head "https://github.com/profclems/glab.git", branch: "trunk"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7fdcd5d7b7f8deea6f21eac3870b07ef745829dd78a12d2a467d601883cc30b8"
    sha256 cellar: :any_skip_relocation, big_sur:       "d30ee4ac25cc9ec3381b3860ac6689a9536373a854f9bf41acb5c21cb1f9e45d"
    sha256 cellar: :any_skip_relocation, catalina:      "54e725987a8860074a52377786de60786d9f16605f69e2c7107c740caf74732d"
    sha256 cellar: :any_skip_relocation, mojave:        "685dd6097fc49199743b317baf7b494e94f076d54a50df91ad845265566df466"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "162bb1538440e9510e531d9a662086e0db62a8395619a48b4bd8cabb6f972b88"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.mac?

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
