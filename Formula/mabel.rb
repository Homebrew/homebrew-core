class Mabel < Formula
  desc "Fancy BitTorrent client for the terminal"
  homepage "https://github.com/smmr-software/mabel"
  url "https://github.com/smmr-software/mabel.git",
      tag:      "v0.1.4",
      revision: "9232e54a58602b9b128a6070b84295c29aa24b27"
  license "GPL-3.0-or-later"
  head "https://github.com/smmr-software/mabel.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d65612058c6fba548cdc354774fb7823407a8fbf88063a1d5373de9514a57d13"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c601135efec31d13150d06f247941fd90ded1eacb1fd375e7655cf7f6fdb4048"
    sha256 cellar: :any_skip_relocation, monterey:       "7140c60b8c79d4e09c413e82ce38b2cc5b48f595ad2a0de50a69b0d819bb0214"
    sha256 cellar: :any_skip_relocation, big_sur:        "a26316c82e2d73349eed2abffb6189ce730e6d0a25b60840ba31955fcc7fc56d"
    sha256 cellar: :any_skip_relocation, catalina:       "67b759ab59fcc778a35243a2dc1bfcd2fdda8d29a8d12f78446b14d0c5f1f890"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "620083e94d2960ee0b692e07ec994842f779d0f3b3d83d5acac7be4e20723c6f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.builtBy=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    vrsn_out = shell_output("#{bin}/mabel --version")
    assert_match "Mabel #{version}", vrsn_out
    assert_match "Built by: #{tap.user}", vrsn_out

    trnt_out = shell_output("#{bin}/mabel 'test.torrent' 2>&1", 1)
    error_message = if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?
      "open /dev/tty: no such device or address"
    else
      "open test.torrent: no such file or directory"
    end
    assert_match error_message, trnt_out
  end
end
