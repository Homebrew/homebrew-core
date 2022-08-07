class Nali < Formula
  desc "Tool for querying IP geographic information and CDN provider"
  homepage "https://github.com/zu1k/nali"
  url "https://github.com/zu1k/nali/archive/v0.5.0.tar.gz"
  sha256 "fd3dabda33a381d0072f9c657098c3c01c793195bc6326015b36c8a168943f1c"
  license "MIT"
  head "https://github.com/zu1k/nali.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5edd5c82696f352f3cb177cb4274b3f707ecf1e4a83185ecfc7dee6159de7d35"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "94792f753375d6eef98c1d460c44a8b021ff66d1dfd1557defcc16f0f07a27f4"
    sha256 cellar: :any_skip_relocation, monterey:       "93c8879f6a626a36961c584049adf87890385dbe197975ebf501aaf86da6fc64"
    sha256 cellar: :any_skip_relocation, big_sur:        "031cc8b4eba9d95bb4f32111a347f1f7ce7b4f555d9fcaf717d4f144a5c0512d"
    sha256 cellar: :any_skip_relocation, catalina:       "a40d10c4700cfccb5b35b29809d9e7a552afedf764f1099677281ffd86690644"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30ced4b8265010d06903d187db61e4a7d65ee2573161acbcc0ea6eb63431f6e3"
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
    # This example reads "Australia APNIC/CloudFlare Public DNS Server".
    assert_match "#{ip} [澳大利亚 APNIC/CloudFlare公共DNS服务器]", shell_output("#{bin}/nali #{ip}")
  end
end
