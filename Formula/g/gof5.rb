class Gof5 < Formula
  desc "F5 BIG-IP VPN client"
  homepage "https://github.com/kayrus/gof5"
  url "https://github.com/kayrus/gof5/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "33356f098a81b4ffa17eb63b440675a920a8cb0319b5f3285985b58f88973fed"
  license "Apache-2.0"
  head "https://github.com/kayrus/gof5.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0ee93bcf3d09a81771d580217796c75dbf33e234f202c5a010eb61522cabef99"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ee93bcf3d09a81771d580217796c75dbf33e234f202c5a010eb61522cabef99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ee93bcf3d09a81771d580217796c75dbf33e234f202c5a010eb61522cabef99"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e94f9c1fa6e77ae7321a5464b93d22636fef18fd533b0638e574cc5e9cffde9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9829dfab109bf82fb320df186c444a8424c9935e588dd5bf59d7e8bcd747266"
    sha256 cellar: :any,                 x86_64_linux:  "f5524a1ccc6b2245c2d819d80a8b376ca15bfecce20e0bc22dd1384ff1167841"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/gof5"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gof5 --version")

    output = shell_output("#{bin}/gof5 --profile-index=-1 2>&1", 1)
    assert_match "profile-index cannot be negative", output
  end
end
