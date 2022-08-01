class Mabel < Formula
  desc "Fancy BitTorrent client for the terminal"
  homepage "https://github.com/smmr-software/mabel"
  url "https://github.com/smmr-software/mabel.git",
      tag:      "v0.1.4",
      revision: "9232e54a58602b9b128a6070b84295c29aa24b27"
  license "GPL-3.0-or-later"
  head "https://github.com/smmr-software/mabel.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a23960e59fe71026596b30f9bebbc16e4a39ff7e072d165ecaff127d55e0941f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ab556e901b131b2fc6d9f94ec20dd5cc84929dd24772afd6b62c6939c4901b73"
    sha256 cellar: :any_skip_relocation, monterey:       "279d19a2e45d86503c03547678bff0696ec50a28a7a1d96f3b6598d5aeca8169"
    sha256 cellar: :any_skip_relocation, big_sur:        "1587e1486203466e8bdafb79858d22d14b543730a2e1b7bbed39f89af2beaf08"
    sha256 cellar: :any_skip_relocation, catalina:       "a768c23d24d13566cdbbb75929767141a8fcbbee20aab3a01df019c08ef57e14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4f2edb7ea7410b9568effafed6c4f57ff2c95ebce6b380cc003423c73badfef"
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
