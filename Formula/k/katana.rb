class Katana < Formula
  desc "Crawling and spidering framework"
  homepage "https://github.com/projectdiscovery/katana"
  url "https://github.com/projectdiscovery/katana/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "d95921d3a4f01b5bdc60416f943d67b1622b222066e3e701f873d2947483b0a7"
  license "MIT"
  head "https://github.com/projectdiscovery/katana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "7547b3381f3f37a42ff0d640f4cdb47aa998c782eaad5450d720de9c295c84a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b3aa8fbaa11155801f8d41d2e8bca59df6c848ff5684adbf3ce9958665ec691f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f337c4f91d142a3f72cfd1568a46761bd728d2970b004b640106b8f94708ff5e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "882c599862fa1cde6101ff80b3fc103294e9b76e705a1486d35b28d3ec06f224"
    sha256 cellar: :any_skip_relocation, sonoma:         "eaa45d8fdd61cfc2f7ce2602ef45fbbf530811890fe789b777f9ee8ffc5a5695"
    sha256 cellar: :any_skip_relocation, ventura:        "00c70f58bc0c7fc7e51640fca83a73fe93656a5f85a6445fd28972a986b71934"
    sha256 cellar: :any_skip_relocation, monterey:       "3d2d71f63d2f100eb8709c1e30ac51e88dd4eb23de9ab07bc507e94f1cc66be4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eade19ed36dee4d421a2148e1bbed74e45b3601b84e0668460b7a4dd02833ba9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/katana"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/katana -version 2>&1")
    assert_match "Started standard crawling", shell_output("#{bin}/katana -u 127.0.0.1 2>&1")
  end
end
