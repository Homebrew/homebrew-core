class Httpx < Formula
  desc "Fast and multi-purpose HTTP toolkit"
  homepage "https://github.com/projectdiscovery/httpx"
  url "https://github.com/projectdiscovery/httpx/archive/v1.2.5.tar.gz"
  sha256 "297b34f574bedd9575926f1e8c9f630a39ab54311bd2df821536359735a2b161"
  license "MIT"
  head "https://github.com/projectdiscovery/httpx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "84fddb1702e2350fa483ccec6db39ac14a4cd091fc65fe85e71dfe8c8f16550f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1355516b141e7ac21bb30c0bac33d679dcc19e98ac7feed519bdba841014523c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "585964258ba8e85fc46dd1248dd7b24038caa23447a526873fe61b3c1250f952"
    sha256 cellar: :any_skip_relocation, ventura:        "c5e9e24ccd105e70c001ff2d8ef3684e1adde013b7261b0199c784e111d4e3a1"
    sha256 cellar: :any_skip_relocation, monterey:       "071a2b2b36b61c09500dd050cf44fd34e9253a725b30cb64b088d0f5d0560c7b"
    sha256 cellar: :any_skip_relocation, big_sur:        "5004552ddee1a3880820e673a64eabae810f35cd3ad690c0578d254ff18abe6f"
    sha256 cellar: :any_skip_relocation, catalina:       "9cb6bde54cc74d7610ba3f3ace0bed4cafc2ef0ac83a8875f2ad39800c53b5db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fa3d131193cb305b89938516dae179deab74b491b487a4affa21c3b6b708705"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/httpx"
  end

  test do
    output = JSON.parse(shell_output("#{bin}/httpx -silent -title -json -u example.org"))
    assert_equal 200, output["status_code"]
    assert_equal "Example Domain", output["title"]
  end
end
