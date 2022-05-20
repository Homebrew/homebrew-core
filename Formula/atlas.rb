class Atlas < Formula
  desc "Database toolkit"
  homepage "https://atlasgo.io/"
  url "https://github.com/ariga/atlas/archive/v0.4.1.tar.gz"
  sha256 "f6927b160eb665d3648c997f34ae06acb5a17dd93ffb5aa3b1ed614d83d87915"
  license "Apache-2.0"
  head "https://github.com/ariga/atlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3867a80fcd3d14368f050330c1991adb365589ce0557ba3e88de371485c8081e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2471ad2e4a0fff51ed33001a5cfc520fd0cfd7d7415575932c9c2fe29b6755e9"
    sha256 cellar: :any_skip_relocation, monterey:       "3c240fb01332d42361e5fad6b9449c7ecc026d26c9ae1bc71c48c9db7ad01cfc"
    sha256 cellar: :any_skip_relocation, big_sur:        "12e9f098bed92ad517b5fa6210ca7d7461215bf3cc843665391f4a1c94bb4dc0"
    sha256 cellar: :any_skip_relocation, catalina:       "67d5c6e7ea4bfd62ea9c7a10faf7eaec992a915b0aa1ab417504669f48975f02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d76051f7e4b5d30e684cbbd99643c2a6938268bec32e98b4f4527f98be2bf73a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X ariga.io/atlas/cmd/atlascmd.version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/atlas"

    bash_output = Utils.safe_popen_read(bin/"atlas", "completion", "bash")
    (bash_completion/"atlas").write bash_output

    zsh_output = Utils.safe_popen_read(bin/"atlas", "completion", "zsh")
    (zsh_completion/"_atlas").write zsh_output

    fish_output = Utils.safe_popen_read(bin/"atlas", "completion", "fish")
    (fish_completion/"atlas.fish").write fish_output
  end

  test do
    assert_match "Error: mysql: query system variables:",
      shell_output("#{bin}/atlas schema inspect -u \"mysql://user:pass@localhost:3306/dbname\" 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/atlas version")
  end
end
