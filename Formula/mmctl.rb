class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mmctl"
  url "https://github.com/mattermost/mmctl.git",
      tag:      "v7.5.1",
      revision: "724e2fd64d753afbd7295ba86641db6aed21496d"
  license "Apache-2.0"
  head "https://github.com/mattermost/mmctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "013ebb592b416fcef1d2f7efc1ef677aedf9d9dc4dc996d0412f58e030f20d99"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2de8013993a6675abb0eb9c4a1034d6173c4852d0d41c7b3a10ad1288f92e33"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "52ff5250e65f33cdadf86c7aade1a2c34fdafd8c244b46c7cddc20af2f012511"
    sha256 cellar: :any_skip_relocation, monterey:       "eec141d5601b52d33d4254d9f4088517aacab85535e99e1378d363c4e3df4275"
    sha256 cellar: :any_skip_relocation, big_sur:        "484098ccaf93051d30babccc46107e0a3776fd78ff491893a04d18ef68fbf8ed"
    sha256 cellar: :any_skip_relocation, catalina:       "2e97a83c24935cd47d411868162ad975b9b2b0b893bd1781fd56c66e8586e6ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08f63941bf44b06e7ceee7231eea24ccbabbea0d7bce636fe914f9eea8f0c907"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/mattermost/mmctl/commands.BuildHash=#{Utils.git_head}"
    system "go", "build", *std_go_args(ldflags: ldflags), "-mod=vendor"

    # Install shell completions
    generate_completions_from_executable(bin/"mmctl", "completion", shells: [:bash, :zsh])
  end

  test do
    output = pipe_output("#{bin}/mmctl help 2>&1")
    refute_match(/.*No such file or directory.*/, output)
    refute_match(/.*command not found.*/, output)
    assert_match(/.*mmctl \[command\].*/, output)
  end
end
