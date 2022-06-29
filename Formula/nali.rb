class Nali < Formula
  desc "Tool for querying IP geographic information and CDN provider"
  homepage "https://github.com/zu1k/nali"
  url "https://github.com/zu1k/nali/archive/v0.4.5.tar.gz"
  sha256 "3eddb93b656e800e7a79cebf0dbfbb68dd33054ad3e11481f541ebe532087cd5"
  license "MIT"
  head "https://github.com/zu1k/nali.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95f0370e7572e33461ea95ccebdf912b6e6f19a35d7abc229298943211a852f6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "997179fdfdbab8eea9ec87ae18ebe12319e9c4c404cbbe0b9ca415c07ed0ab68"
    sha256 cellar: :any_skip_relocation, monterey:       "323651c9075f7d67f4d05384df6ca2008810e52f89e7f2bde5b8a9dea478d560"
    sha256 cellar: :any_skip_relocation, big_sur:        "ba0c204520e18c3820b1e8b241c581c4e5cb187eec49ae3b390aae1c012c4042"
    sha256 cellar: :any_skip_relocation, catalina:       "68d6a9265655b0db2999d5c43268481986db003274a63e84ea3c5f3267edaab3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf448017cca99cb26779e72e7128168d9ebfee6a18797b3d07b19885ca10122c"
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
