class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://glab.readthedocs.io/"
  url "https://github.com/profclems/glab/archive/v1.19.0.tar.gz"
  sha256 "693fa7d81e50a1a029eec94b0d1a779f2627d17a4a73d4d40d833242a3ff7b1b"
  license "MIT"
  head "https://github.com/profclems/glab.git", branch: "trunk"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a9e2f92b85bce29064ab9a5838d69e0a7b4e9b52e5b0d263679aee55af22d385"
    sha256 cellar: :any_skip_relocation, big_sur:       "0b35467121daf118a58f33078e38825e73749cd02c4423fbf2d0e80db66074e3"
    sha256 cellar: :any_skip_relocation, catalina:      "c237693542254e268e1ebc564062880ad418924704d0f3cf80ceb0871ef89abb"
    sha256 cellar: :any_skip_relocation, mojave:        "51cb6272895264ac5fb4e45fac1ecf6588646203637e2dcff4da762a427a0b63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5846d7c207d9f7a987baa98fa1c1bea1aafb3a154f316a28667fa618303ae26"
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
