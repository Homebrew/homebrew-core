class Mabel < Formula
  desc "Fancy BitTorrent client for the terminal"
  homepage "https://github.com/smmr-software/mabel"
  url "https://github.com/smmr-software/mabel.git",
      tag:      "v0.1.6",
      revision: "4b594b8adb589c466c1fad661016792ef07a1408"
  license "GPL-3.0-or-later"
  head "https://github.com/smmr-software/mabel.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a3961c11fa3bf9435fe1b26b243660ef2121384387672d13ebf16c8aaae7f112"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97cfdf838faaed2ac42530932354e9be4b7c5d4e6abec6168f11bf14aa302f1a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "db387b01505c1d28d97aa8551b66a23655a8b21e3ffd553f830ecbdba74ab1ed"
    sha256 cellar: :any_skip_relocation, ventura:        "5788303936ab4cabcba24c2fa02afc733e4d7b71be327b830499fd90909c356d"
    sha256 cellar: :any_skip_relocation, monterey:       "17588697f1cb530ff498aaa1060e79a3474215b2be8653e611c18deaed3d16e9"
    sha256 cellar: :any_skip_relocation, big_sur:        "deb9adc1cb8f5ad3d6655e3e16fff9c5be3f5527b03224a192ba35d9339040f9"
    sha256 cellar: :any_skip_relocation, catalina:       "79283f76f6003ed4814d791de60b4689b1e51a1cbbd0efa12220d90ce3c80756"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1bef6b6aa347b701a37aff20108af879c617b18a333df2feed670b08da89098"
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
