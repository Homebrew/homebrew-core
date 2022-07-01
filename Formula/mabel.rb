class Mabel < Formula
  desc "Fancy BitTorrent client for the terminal"
  homepage "https://github.com/smmr-software/mabel"
  url "https://github.com/smmr-software/mabel.git",
      tag:      "v0.1.3",
      revision: "fab9619f85a47e17959a7d00316466c1714747c6"
  license "GPL-3.0-or-later"
  head "https://github.com/smmr-software/mabel.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f84c4d3b1594570eb952307790cd6e7b6c134003e2f328a0516bff06e0d2ac5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "53e2dd0e08156ee7187fef2355707572882393ec025d15c387a22b83bd1227ef"
    sha256 cellar: :any_skip_relocation, monterey:       "82da9ab9d771917ac53270cf7a67488340a4f17a4781f7de786babe0f586a8e1"
    sha256 cellar: :any_skip_relocation, big_sur:        "331b7e15e56afe8873dc55c19bf8ab633753f1a57a435aa28d500349c19a8b2e"
    sha256 cellar: :any_skip_relocation, catalina:       "6aa37bb0c0a22a2c2f1511741baaa9e7fa16010a040e6ca539df9c425e2ed670"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77d2cb25d2e883d4c0904ac5b0d4911f8bef270909c2e453878ac53cd286a2ee"
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
