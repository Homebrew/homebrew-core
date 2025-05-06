class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego/archive/refs/tags/v4.23.1.tar.gz"
  sha256 "e86e62946397964d6f2db2a2487cc75acac08e9ad7811c2302d56c35ca521699"
  license "MIT"
  head "https://github.com/go-acme/lego.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "949df3c4a3249e34ba50ff646a843c7108902b2db207efcdab1e173534253edb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "949df3c4a3249e34ba50ff646a843c7108902b2db207efcdab1e173534253edb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "949df3c4a3249e34ba50ff646a843c7108902b2db207efcdab1e173534253edb"
    sha256 cellar: :any_skip_relocation, sonoma:        "f391914bc2388a4f46ec084b668e451d00260febda14f479b0bce6bdd056d2e4"
    sha256 cellar: :any_skip_relocation, ventura:       "f391914bc2388a4f46ec084b668e451d00260febda14f479b0bce6bdd056d2e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68b1c2c9033779e35513cd2455aee66188b6e77ccfffbcbacdce0cb52eecb1d6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/lego"
  end

  test do
    output = shell_output("#{bin}/lego -a --email test@brew.sh --dns digitalocean -d brew.test run 2>&1", 1)
    assert_match "some credentials information are missing: DO_AUTH_TOKEN", output

    output = shell_output(
      "DO_AUTH_TOKEN=xx #{bin}/lego -a --email test@brew.sh --dns digitalocean -d brew.test run 2>&1", 1
    )
    assert_match "Could not obtain certificates", output

    assert_match version.to_s, shell_output("#{bin}/lego -v")
  end
end
