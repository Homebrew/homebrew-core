class Monocle < Formula
  desc "See through all BGP data with a monocle"
  homepage "https://github.com/bgpkit/monocle"
  url "https://github.com/bgpkit/monocle/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "4aff8f4d13b300f87d6ef49dbb417dc2cbcdbbd3cc64babb0affdc2c3d663aa3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "717863ac871ca2a23689d7bf2608d90a29d84a9892a0c462e26c8a8ce4efe941"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d45c95a584a8a539210a47700489e61c9e66ee4d491c0771d1cf179aeb9a0656"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "92e9008c7af307dca992a817e103c3781d9b43a0ebd07a9c970636affcc905d4"
    sha256 cellar: :any,                 arm64_linux:       "befc7ad74af3aae3810347c9ae044567d0443c9fb0947e640fbb25c23aac5123"
    sha256 cellar: :any,                 x86_64_linux:      "6846561db60afb904409ea4daac7241f50f683c851b6b08749b17aa04437b706"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/monocle time 1735322400 --simple")
    assert_match "2024-12-27T18:00:00+00:00", output
  end
end
