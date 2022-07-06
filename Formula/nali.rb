class Nali < Formula
  desc "Tool for querying IP geographic information and CDN provider"
  homepage "https://github.com/zu1k/nali"
  url "https://github.com/zu1k/nali/archive/v0.4.8.tar.gz"
  sha256 "ce6a0be171839640634047f90fb40eafda17dd4439329df0caf110ce186bfc91"
  license "MIT"
  head "https://github.com/zu1k/nali.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff5b4a5b63e41068fb53d1b64ce5731a4ae0beb7a9195a7e8d3797dea12cb8ec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c1a88f6d3a194e8809aff3158847b291623ef17f1b812faac4e790daaab08987"
    sha256 cellar: :any_skip_relocation, monterey:       "191ae60904bfcf17d5eede4f1ebca9905a7ccf200b0ad33dd1e0bb7379cf5950"
    sha256 cellar: :any_skip_relocation, big_sur:        "838721f7469b809baf29137ad32fcde22cdfc708079b87429bb2dd032dba8bb5"
    sha256 cellar: :any_skip_relocation, catalina:       "bd10ed0576a21abe2198bc995e9fa9eb130e1827558213fc77982afe7f8e66c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff99592469a9843ae3f40632617d6b649e9f47c02bf2b01f3954d0ad43656da7"
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
