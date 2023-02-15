class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mmctl"
  url "https://github.com/mattermost/mmctl.git",
      tag:      "v7.8.0",
      revision: "f61f2a08684ece90f23b02bfecea0b772f1653e9"
  license "Apache-2.0"
  head "https://github.com/mattermost/mmctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b67c877e8b7d6957b632ef38d58ddf5abeb494394812885588ceecf455650cfd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4aa860627f6abeee5ebdb771af6f1b9aafdcf2b61dab268c20e828812d8df5a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "81ffebf37c67ba642a0c31ea69fb54bd8e772a72b0bd8567b4217a3420b2121d"
    sha256 cellar: :any_skip_relocation, ventura:        "a54d484fbc85f35b083d212d75371acde348e32654c23df503c011c7bc2b850d"
    sha256 cellar: :any_skip_relocation, monterey:       "6e1024e458946873ffbb76bc3683efda269bb7f2c61fdf4bbc06615ee79a4fbd"
    sha256 cellar: :any_skip_relocation, big_sur:        "b1b125bd960f4a91edaac787d4375a531f5fe2d6f459748ac01e445538901813"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f797db779c80ad6166c7ad9ef181af67c9e6bb777d24bc5232972474fcbc516a"
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
