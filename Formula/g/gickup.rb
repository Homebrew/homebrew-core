class Gickup < Formula
  desc "Backup all your repositories with Ease"
  homepage "https://cooperspencer.github.io/gickup-documentation/"
  url "https://github.com/cooperspencer/gickup/archive/refs/tags/v0.10.28.tar.gz"
  sha256 "b7eb8d84908e04ee61b6a835b947c3817f610698ec22d1a876966457f7ce90c2"
  license "Apache-2.0"
  head "https://github.com/cooperspencer/gickup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cb5a547ffda82468488d48a2ccd0f8b52b566284ccbf098c99c473edb5d4bb0f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c19bbc9b9a56d10b313ea4b3bd27625074174cbb3c6aa284f28dd595edf085f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e5fe73366053db6e4b12e0c44ac0291c7e6f5a6022ad3d90d0b25dca67c848f"
    sha256 cellar: :any_skip_relocation, sonoma:         "3abc6427495df1d2a82c18b20142b6deb0f2066da4bba8bb61677da6194314d0"
    sha256 cellar: :any_skip_relocation, ventura:        "725cceb4980b9cf53704779a6f8de2411e46aa67e9e3c074695bb0d12deb353a"
    sha256 cellar: :any_skip_relocation, monterey:       "c015e9b8015d366baff2c5eb40fd57513318ef31d54d402f87d83c3828164a7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "111608b9615d535f2a0291c7f89c4eba417de7777e8c3e27c6d4754ee650a531"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
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
