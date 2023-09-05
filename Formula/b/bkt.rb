class Bkt < Formula
  desc "CLI utility for caching the output of subprocesses"
  homepage "https://www.bkt.rs"
  url "https://github.com/dimo414/bkt/archive/refs/tags/0.7.1.tar.gz"
  sha256 "ac36ff1015ebbec57d8b9141e88c7ad36423e6abaf35551e3ca715e173c6c835"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dc30464dba54c65f53cdc3439c48b3fb533fb9534c62aadff286739e3da9b8df"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27cbb8f9a4928e7ca87ff458a2481221300da6ffbc253be3a56a47d7e35765e0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "db83f90396caad01bae1f9f51589f651f9218f914e977a0664702049e03beffa"
    sha256 cellar: :any_skip_relocation, ventura:        "2f207ee237121d3b386a665473fe66bd685781ac7be987be3d839d54aac2a81b"
    sha256 cellar: :any_skip_relocation, monterey:       "fa805c2d9b6b611594e1662937dc29f7ae78a92ef45964ceb78769b780371d37"
    sha256 cellar: :any_skip_relocation, big_sur:        "c7db1c6af6bb8edadb82c5414bdc620cd9feb4210f30d1f83f217ecdbf298316"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c34524bbf630f6c5c9f7cc0d719a572fd89a1cce33aa3ca25f514b8540d9a66b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Make sure date output is cached between runs
    output1 = shell_output("#{bin}/bkt --ttl=1m -- date +%s.%N")
    sleep(1)
    assert_equal output1, shell_output("#{bin}/bkt --ttl=1m -- date +%s.%N")
  end
end
