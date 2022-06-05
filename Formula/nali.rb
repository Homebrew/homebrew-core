class Nali < Formula
  desc "Tool for querying IP geographic information and CDN provider"
  homepage "https://github.com/zu1k/nali"
  url "https://github.com/zu1k/nali/archive/v0.4.2.tar.gz"
  sha256 "25842823d61b1c05d8e261c28a2f24232838a1397cbe3b227a2c6288ec451fd6"
  license "MIT"
  head "https://github.com/zu1k/nali.git", branch: "master"

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
