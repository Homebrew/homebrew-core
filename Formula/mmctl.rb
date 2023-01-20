class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mmctl"
  url "https://github.com/mattermost/mmctl.git",
      tag:      "v7.7.1",
      revision: "2a539c02d71d1674ccb1db462e5be35a1462fc9a"
  license "Apache-2.0"
  head "https://github.com/mattermost/mmctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "079f260f8b5ec6d56a6c5940b0e8e82b6328f85f5dbee76b7cbe1606f4c24a7b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4cf466b9bbb4775c1f7e0acf97f92f0e72d2f3457838d7c0e875babdec62b2ef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "949a7d8216355b7537b7518ed3b2068930b3aede11ec02b53d07c717cebad165"
    sha256 cellar: :any_skip_relocation, ventura:        "2e99408fd207df11897aef5e7c9ff745afd4af80682ad8fe1bb839a78b24dfe3"
    sha256 cellar: :any_skip_relocation, monterey:       "012e215781385841f6e95e52e2247e4145b375ffa7ff221869ce0658b971c3c5"
    sha256 cellar: :any_skip_relocation, big_sur:        "fc51b4dd21a258b5c53ddc1c11e87ff494ec36e17d0cf032b45276302f33f154"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "835b2abebd89a7b905d8bf786dfe210350a09e74d6b03a29fdca0580331f7a91"
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
