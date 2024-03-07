class Ntfy < Formula
  desc "Send push notifications to your phone or desktop via PUT/POST"
  homepage "https://ntfy.sh/"
  url "https://github.com/binwiederhier/ntfy.git",
      tag:      "v2.9.0",
      revision: "8c69234e285fdc5cae6772bde1f52bbbc2283c7d"
  license any_of: ["Apache-2.0", "GPL-2.0-only"]
  head "https://github.com/binwiederhier/ntfy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4d3313080b3f69cbf3e4342ca70e317402fe3f9c51bc796917615604ecff79d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4d3313080b3f69cbf3e4342ca70e317402fe3f9c51bc796917615604ecff79d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d3313080b3f69cbf3e4342ca70e317402fe3f9c51bc796917615604ecff79d2"
    sha256 cellar: :any_skip_relocation, sonoma:         "7dce9a30984c0f91b4673dacfcdd479275e4e0c4f93997d6ab2993bbb1dce6fd"
    sha256 cellar: :any_skip_relocation, ventura:        "7dce9a30984c0f91b4673dacfcdd479275e4e0c4f93997d6ab2993bbb1dce6fd"
    sha256 cellar: :any_skip_relocation, monterey:       "7dce9a30984c0f91b4673dacfcdd479275e4e0c4f93997d6ab2993bbb1dce6fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffe5491e47e50debe535844d72d0762199820e4ec68d03af910606ff558d7e21"
  end

  depends_on "go" => :build

  def install
    system "make", "cli-deps-static-sites"
    ldflags = %W[
      -X main.version=#{version}
      -X main.date=#{time.strftime("%F")}
      -X main.commit=#{Utils.git_head}
      -s
      -w
    ]
    with_env(
      "CGO_ENABLED" => "0",
    ) do
      system "go", "build", *std_go_args(ldflags:), "-tags", "noserver"
    end
  end

  test do
    require "securerandom"
    random_topic = SecureRandom.hex(6)

    ntfy_in = shell_output("#{bin}/ntfy publish #{random_topic} 'Test message from HomeBrew during build'")
    ohai ntfy_in
    sleep 5
    ntfy_out = shell_output("#{bin}/ntfy subscribe --poll #{random_topic}")
    ohai ntfy_out
    assert_match ntfy_in, ntfy_out
  end
end
