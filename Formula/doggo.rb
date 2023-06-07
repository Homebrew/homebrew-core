class Doggo < Formula
  desc "Command-line DNS Client for Humans"
  homepage "https://doggo.mrkaran.dev/"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/mr-karan/doggo.git", branch: "main"

  stable do
    url "https://github.com/mr-karan/doggo/archive/refs/tags/v0.5.5.tar.gz"
    sha256 "7ba1340ce46566ca8fa1565ef261519dee5b1c7007aea97eb1f9329f8a3f0403"

    # patch for quic-go, remove when it is available
    patch do
      url "https://github.com/mr-karan/doggo/commit/7db5c2144fa4a3f18afe1c724b9367b03f84aed7.patch?full_index=1"
      sha256 "e34f71e6618817edfd0d7b01657a407e9573e74a7ea89d048abc95bac46bb21e"
    end
  end

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
