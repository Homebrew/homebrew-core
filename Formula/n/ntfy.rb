class Ntfy < Formula
  desc "Send push notifications to your phone or desktop via PUT/POST"
  homepage "https://ntfy.sh/"
  url "https://github.com/binwiederhier/ntfy.git",
      tag:      "v2.7.0",
      revision: "2f0ec88f40418660e5b99a7ad589d661d8c4ff6f"
  license any_of: ["Apache-2.0", "GPL-2.0-only"]
  head "https://github.com/binwiederhier/ntfy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "29be8f25881322e5c1b5154c3e3b9c7bfdd74b550eafdfd10df60815a64eda64"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29be8f25881322e5c1b5154c3e3b9c7bfdd74b550eafdfd10df60815a64eda64"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "29be8f25881322e5c1b5154c3e3b9c7bfdd74b550eafdfd10df60815a64eda64"
    sha256 cellar: :any_skip_relocation, ventura:        "9f6a4c9ad4c6c17e7e680644fa50e78fbab475a209c2af06680d7b0cfdc62482"
    sha256 cellar: :any_skip_relocation, monterey:       "9f6a4c9ad4c6c17e7e680644fa50e78fbab475a209c2af06680d7b0cfdc62482"
    sha256 cellar: :any_skip_relocation, big_sur:        "9f6a4c9ad4c6c17e7e680644fa50e78fbab475a209c2af06680d7b0cfdc62482"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46d20995998868f11cce74529f74483dd195a7a07fcb849b3ce60439cd950ec3"
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
      system "go", "build", *std_go_args(ldflags: ldflags), "-tags", "noserver"
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
