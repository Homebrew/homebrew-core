class Nali < Formula
  desc "Tool for querying IP geographic information and CDN provider"
  homepage "https://github.com/zu1k/nali"
  url "https://github.com/zu1k/nali/archive/v0.4.4.tar.gz"
  sha256 "7d577259eaf10bcce7e1c3e38d480ca47915926a1b1ad190a9f9657f1e74c819"
  license "MIT"
  head "https://github.com/zu1k/nali.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78b806034521ab4dcc378eee83aac773985124c01203da1a7d53784a31b4f09a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5bd0f157755d3a9a4e7b36207acaf72577571d378193f1aaee027a118f762b53"
    sha256 cellar: :any_skip_relocation, monterey:       "d6ea226cbdf09496a2fde7d5fd6601abbc0ff7def9e759343b52a991334522e5"
    sha256 cellar: :any_skip_relocation, big_sur:        "094cf2dac59ce6d3701ce109ca96ae21c65a1e5d25a684649e4ce43a1cc7575a"
    sha256 cellar: :any_skip_relocation, catalina:       "988b3ebbe68d0c9cce3a03979fb7599fe86ebc689e79d25168c5de0fea4609f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ed876181909d010ec85c5b4b73d8bfe78f5419492b27fc79d8c380f268fdb76"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    (bash_completion/"nali").write Utils.safe_popen_read(bin/"nali", "completion", "bash")
    (fish_completion/"nali.fish").write Utils.safe_popen_read(bin/"nali", "completion", "fish")
    (zsh_completion/"_nali").write Utils.safe_popen_read(bin/"nali", "completion", "zsh")
  end

  test do
    ip = "1.1.1.1"
    # Default database used by program is in Chinese, while downloading an English one
    # requires an third-party account.
    # This example reads "US APNIC&CloudFlare Public DNS Server".
    assert_match "#{ip} [美国 APNIC&CloudFlare公共DNS服务器]", shell_output("#{bin}/nali #{ip}")
  end
end
