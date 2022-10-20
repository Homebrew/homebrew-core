class Doggo < Formula
  desc "Command-line DNS Client for Humans"
  homepage "https://doggo.mrkaran.dev/"
  url "https://github.com/mr-karan/doggo/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "81815c4b1230109d2ec5767dccb4a486468b214d3f3fa9ac7ed41463e01260cf"
  license "GPL-3.0-or-later"
  head "https://github.com/mr-karan/doggo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "047bdd261712857f6c8cf8644b33670da8fbfb83035589e06924e675f41a8617"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "47203457278798c08c74e6e048f036e8ef1a3579c329a43de903f270374f16e8"
    sha256 cellar: :any_skip_relocation, monterey:       "16e3025df96d2b684e0c946b089f63ead6876552213c23ccf04e0e0791880b75"
    sha256 cellar: :any_skip_relocation, big_sur:        "56d48773f860eea3955bec5939c04e5dd1cb30ffdc5774711b0cb09c461b6c60"
    sha256 cellar: :any_skip_relocation, catalina:       "6bbf6b52c703cd3ae160011c5d3df3d26baf39d08c4748be596bf5dd47782cd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "656758ccedb107018e5cba479e134d17295fa939771162d8d2e001738dec89eb"
  end

  # Required lucas-clemente/quic-go >= 0.28
  # Try to switch to the latest go on the next release
  depends_on "go@1.18" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.buildVersion=#{version}
      -X main.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/doggo"

    zsh_completion.install "completions/doggo.zsh" => "_doggo"
    fish_completion.install "completions/doggo.fish"
  end

  test do
    answer = shell_output("#{bin}/doggo --short example.com NS @1.1.1.1")
    assert_equal "a.iana-servers.net.\nb.iana-servers.net.\n", answer

    assert_match version.to_s, shell_output("#{bin}/doggo --version")
  end
end
