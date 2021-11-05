class Mmark < Formula
  desc "Powerful markdown processor in Go geared towards the IETF"
  homepage "https://mmark.miek.nl/"
  url "https://github.com/mmarkdown/mmark/archive/v2.2.17.tar.gz"
  sha256 "e40ef682b3cdc7a479cfafad3e70261194183eb302c072485e0d656ea3c2963b"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e8a5743fe218d357770a6cf6be20b15d5f6285417b210bc7638ac5acc9e43a0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "68492b698df4367e4df47169b0eaa9b6525332d1370ac0584f5d4e44354568ba"
    sha256 cellar: :any_skip_relocation, monterey:       "4b9c510866a0eb497a0baebc1d32329fd934afb5893983310b0c826c05d97906"
    sha256 cellar: :any_skip_relocation, big_sur:        "43a495c72b63b05ad45f72ceea9a740f123ad94ab21c277d20062e40189c75dd"
    sha256 cellar: :any_skip_relocation, catalina:       "43a495c72b63b05ad45f72ceea9a740f123ad94ab21c277d20062e40189c75dd"
    sha256 cellar: :any_skip_relocation, mojave:         "43a495c72b63b05ad45f72ceea9a740f123ad94ab21c277d20062e40189c75dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8faa5cfc2180bcb920e40378d19e18513c9a83d3d26e8560100ffb378ddaead"
  end

  depends_on "go" => :build

  resource "test" do
    url "https://raw.githubusercontent.com/mmarkdown/mmark/v2.2.17/rfc/2100.md"
    sha256 "0e12576b4506addc5aa9589b459bcc02ed92b936ff58f87129385d661b400c41"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    man1.install "mmark.1"
  end

  test do
    resource("test").stage do
      assert_match "The Naming of Hosts", shell_output("#{bin}/mmark -ast 2100.md")
    end
  end
end
