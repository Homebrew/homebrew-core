class Dysk < Formula
  desc "Linux utility to get information on filesystems, like df but better"
  homepage "https://dystroy.org/dysk/"
  url "https://github.com/Canop/dysk/archive/refs/tags/v3.6.0b.tar.gz"
  version "3.6.0b"
  sha256 "59125412523853348218ff57eb1f58f31158e88dc172949d1007b4adbc7a4e61"
  license "MIT"
  head "https://github.com/Canop/dysk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "366d54f71dba6ce58a5ca64e2a8561551b340bdf1e3d52498d800efaf1aa7c5a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aef9d630a5ba657b74b295775c3a19e9072e19e03726b5a8f933361301cf5c97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "718e434dcb2b54dee7ca3df2764da8f5c331c6f3f27c5c426fba3b2aaed19ce7"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2f5c8b0a8f40862bd421c3f96aaddee953081ae05dbdfbf51d1d4b6e0d023f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af63dcd71ad867a4f2f4cf96470b849fe98525a6acc0e1e5bbaf0c93f5625dd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62f95398884b8163b40965f5171b8ff860daf06b5c0320ebea65125a4ef8f0ac"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "filesystem", shell_output("#{bin}/dysk -s free-d")
    assert_match version.to_s, shell_output("#{bin}/dysk --version")
  end
end
