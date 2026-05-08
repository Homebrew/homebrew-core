class Gickup < Formula
  desc "Backup all your repositories with Ease"
  homepage "https://cooperspencer.github.io/gickup-documentation/"
  url "https://github.com/cooperspencer/gickup/archive/refs/tags/v0.10.42.tar.gz"
  sha256 "05adc486f5f6a72b173ef1921608a9458d560e422010b78c780703943afd8ebc"
  license "Apache-2.0"
  head "https://github.com/cooperspencer/gickup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb91b4e0de9549b1f632da978c55621f80986638734aa0b9413bc93ac10282cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a09f3c1e8fc32fd2c149bdd8639c931016af18c22b3ce040e00ca36b7e25536"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f40e658df81056168221488f0d1d4f817e0585f801abad60d609ab83f1b2864e"
    sha256 cellar: :any_skip_relocation, sonoma:        "d23de7084e873035200d392f1476501cfeef99efa20bf014ae694dc24c1262e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d363bfa908fb3060125c9ff78fb65d9d3bc914eb31d418d5505e913162575334"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "960e3cfdf006c0f4a212e362d16aaf90a2694b6f2bb68f44741470b84a08bfb6"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    (testpath/"conf.yml").write <<~YAML
      source:
        github:
          - token: brewtest-token
            user: Brew Test
            username: brewtest
            password: testpass
            ssh: true
    YAML

    output = shell_output("#{bin}/gickup --dryrun 2>&1", 1)
    assert_match "grabbing the repositories from Brew Test", output

    assert_match version.to_s, shell_output("#{bin}/gickup --version")
  end
end
