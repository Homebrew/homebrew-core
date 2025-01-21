class Httpx < Formula
  desc "Fast and multi-purpose HTTP toolkit"
  homepage "https://github.com/projectdiscovery/httpx"
  url "https://github.com/projectdiscovery/httpx/archive/refs/tags/v1.6.9.tar.gz"
  sha256 "cd50750e8a1c625ecb1548bf3d1fa7597732cc5e1ec15f2fbe7b8309a366461c"
  license "MIT"
  head "https://github.com/projectdiscovery/httpx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f593d71b0422ef10a5cd3313a0fa51255b14d4a71981757531481e6da9aea40"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e91b204a5f93adba022a3c691bd60bdf2500e7e0c748d446bb8b0014847c11a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b97cf6f48475a0b9501fac18bafa5c1ebd7eddf09d6ded27389df16472f069c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "d59c63dbbf37041313f3bf29a6a8cced0b0bd70529e583691ef56dfaf36285df"
    sha256 cellar: :any_skip_relocation, ventura:       "bfc9400cfdbf858b1c7028e19d46fad04d1105fd4a5cc6468abd489fcdae7a77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d19c3b97fc344ecc099e98181865f993a363429abe0597af80fbe2ed105c1d2"
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
