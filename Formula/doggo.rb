class Doggo < Formula
  desc "Command-line DNS Client for Humans"
  homepage "https://doggo.mrkaran.dev/"
  url "https://github.com/mr-karan/doggo/archive/refs/tags/v0.5.6.tar.gz"
  sha256 "1965f4c909991bc38b65784ccbc03f4760214bca34f1bb984999f1fc8714ff96"
  license "GPL-3.0-or-later"
  head "https://github.com/mr-karan/doggo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9ed48319e2b05a4af4ca5db6cf53db7c50937a2fcafacfaf0c4fe27864e10f81"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ed48319e2b05a4af4ca5db6cf53db7c50937a2fcafacfaf0c4fe27864e10f81"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ed48319e2b05a4af4ca5db6cf53db7c50937a2fcafacfaf0c4fe27864e10f81"
    sha256 cellar: :any_skip_relocation, ventura:        "bce53f03da69b5135c981d6f70e6b6ca483e286b7a6bfc225553bd8ae6f11fee"
    sha256 cellar: :any_skip_relocation, monterey:       "bce53f03da69b5135c981d6f70e6b6ca483e286b7a6bfc225553bd8ae6f11fee"
    sha256 cellar: :any_skip_relocation, big_sur:        "bce53f03da69b5135c981d6f70e6b6ca483e286b7a6bfc225553bd8ae6f11fee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac0c6551b944673b293cc5cceb253a1f9e6663efa4b5ac73fe71f0348cfdbfd3"
  end

  depends_on "go" => :build

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
