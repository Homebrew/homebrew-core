class Gickup < Formula
  desc "Backup all your repositories with Ease"
  homepage "https://cooperspencer.github.io/gickup-documentation/"
  url "https://github.com/cooperspencer/gickup/archive/refs/tags/v0.10.21.tar.gz"
  sha256 "df45af65b131e1318a689b7f16c35104fc94d181e253f1b9df7715c21e3eb883"
  license "Apache-2.0"
  head "https://github.com/cooperspencer/gickup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a67f4438803fc07aabad3e5e1060af93a2fb7ccb20824ecccfe863a405c4b7d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8b4eee2b5168b05cdca5d6f3f589f87305e4c44ccd88a4f462450bae4df985f1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dddca878e240d3227cbbcb65a866504dbfbe872fa8586a3dfedade18a2d0104d"
    sha256 cellar: :any_skip_relocation, sonoma:         "ee13dd0294ecd2a41f304a776b93ce268cbc029e6e08204d0e204178585b12ab"
    sha256 cellar: :any_skip_relocation, ventura:        "2beb3d4693e06482ed3585c43087b77cd172f836e9c8c2832076dc96f9f3b2f7"
    sha256 cellar: :any_skip_relocation, monterey:       "61f6596a8fe769ca0d5b261ee619cfc6cc22299ec1632f0262bd15444a1ea4df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "efd535dcd24e432c749b331e769440b4a113934637fbab0a07f7f743c2adc047"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    (testpath/"conf.yml").write <<~EOS
      source:
        github:
          - token: brewtest-token
            user: Brew Test
            username: brewtest
            password: testpass
            ssh: true
    EOS

    output = shell_output("#{bin}/gickup --dryrun 2>&1")
    assert_match "grabbing the repositories from Brew Test", output

    assert_match version.to_s, shell_output("#{bin}/gickup --version")
  end
end
