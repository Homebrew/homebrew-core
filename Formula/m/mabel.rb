class Mabel < Formula
  desc "Fancy BitTorrent client for the terminal"
  homepage "https://github.com/smmr-software/mabel"
  url "https://github.com/smmr-software/mabel.git",
      tag:      "v0.1.7",
      revision: "1e74a44f69ce86a0ada6d162c0dabcf2ad3c5077"
  license "GPL-3.0-or-later"
  head "https://github.com/smmr-software/mabel.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "960ea70939b5cd3392ea1390f43e87e9d2690a03ca8a2e602935dcc381a8df8e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "1dd81700a7baedc7bca0ec9daa263464c693f57f56cdcbb57e2def3449207e01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7bf38463d084fe08c99e94d6db50a410bba56792550bacb94e360246eba52620"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1d9a2e1ca4eafe45d6cc7a28fe77631cc32dffaf3d766f4991cb467fd21ae531"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "633e0d76b3a7368f5c84544996dca69a93e8c0e3a0a0646f4123629e027d8fba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5411828b95a20f7b4b0364b10edf02fe510da922fde1bb014f1b2ed2e6f01603"
    sha256 cellar: :any_skip_relocation, sonoma:         "aa4371cca2ceb58486dd3a0c57e4952a8448f749c6c0657aaade9287dacf66b4"
    sha256 cellar: :any_skip_relocation, ventura:        "d716d6bc90d55927c92b18046ef89baf4f13dc24c3419c22e288384784c3e8d6"
    sha256 cellar: :any_skip_relocation, monterey:       "0f44e456ff3baaf737ccc551b9d35f9861b8bc9167bf07e4fbf9cf8685932bf8"
    sha256 cellar: :any_skip_relocation, big_sur:        "6844db2f3fdffac755f626c6875b5f06eb80ea389dd7d2ff67d685ba50a88325"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "e510772573fb47351b50ae37138a50e34b9ef23e735f5848e573c1d8b7a880de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2924f4b5c702e64acc23bd090f4897e06d83473711921aed113391b7fb9e0bcb"
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
    system "go", "build", *std_go_args(ldflags:)
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
