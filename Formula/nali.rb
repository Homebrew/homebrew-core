class Nali < Formula
  desc "Tool for querying IP geographic information and CDN provider"
  homepage "https://github.com/zu1k/nali"
  url "https://github.com/zu1k/nali/archive/v0.4.2.tar.gz"
  sha256 "25842823d61b1c05d8e261c28a2f24232838a1397cbe3b227a2c6288ec451fd6"
  license "MIT"
  head "https://github.com/zu1k/nali.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9779858fa5e59b34c1a8ab33150339439a84d6607d25ee81095fae4dcc83b9d4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "94dbeeafae06df614d9e640d778134d40569bd35210e9136ee1fef75b08d3f4d"
    sha256 cellar: :any_skip_relocation, monterey:       "65a2da9fbd972a5138301fb7b9151c713985a8279b1a08ac05c56caa3174eae8"
    sha256 cellar: :any_skip_relocation, big_sur:        "4c679e337c08d4e6d1765b03f8a62b7839987f8837ef03b209729756f9152213"
    sha256 cellar: :any_skip_relocation, catalina:       "846258835c94643f8a6176dc5e810e38ef8312e39de7789f0e464c8adfb559e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "829a456ebfb36902db111576ebff96c8c824b9939ecf426492a2e93adf35eb43"
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
