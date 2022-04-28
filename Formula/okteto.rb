class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/2.2.1.tar.gz"
  sha256 "9a318fc7d7681f655ba72dbe4271e3a49a12b3c781951a59ad802dd9bc3b0a45"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d23be61de40cbffc8e6cc144bd8ab2c450fef86b82b1554bdc8a4a3aa747f933"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "288e9ffa4ffcaed0f91f321a29a9bd2f45539422c8310842bd106bd2a0c287de"
    sha256 cellar: :any_skip_relocation, monterey:       "1b76428414d0c90f1dcbf51ffa689bf3e355e65a738eadcbcc5dd7ebc043d34c"
    sha256 cellar: :any_skip_relocation, big_sur:        "f5a744d9b01955ea9bfa7a9a59aba4501ee55f7ce1fc80f88db60eff67c9939f"
    sha256 cellar: :any_skip_relocation, catalina:       "5d75b0858b4bf943f7d1778ccf3867bf36bdf356ec10a5a6af2f750b7445b9d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab95448095b7c60bd30dee1df11a94e2d600bdd41682e26e33e4b2ff9df3c946"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", tags

    bash_output = Utils.safe_popen_read(bin/"okteto", "completion", "bash")
    (bash_completion/"okteto").write bash_output
    zsh_output = Utils.safe_popen_read(bin/"okteto", "completion", "zsh")
    (zsh_completion/"_okteto").write zsh_output
    fish_output = Utils.safe_popen_read(bin/"okteto", "completion", "fish")
    (fish_completion/"okteto.fish").write fish_output
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    assert_match "Please run 'okteto context' to select one context",
      shell_output(bin/"okteto init --context test 2>&1", 1)

    assert_match "No contexts are available.",
      shell_output(bin/"okteto context list 2>&1", 1)
  end
end
