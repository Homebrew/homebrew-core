class Jaq < Formula
  desc "JQ clone focussed on correctness, speed, and simplicity"
  homepage "https://github.com/01mf02/jaq"
  url "https://github.com/01mf02/jaq/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "185c4b73d128d5af18245d4a514c017e24ddb98b02569357adf4394c865847cf"
  license "MIT"
  head "https://github.com/01mf02/jaq.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e64e2d913e8633078d32b5caf9d03e9e09b401ecd562dd504f24b921eed1f1f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fe65aff4dc820945228632ba1ada2d74dd29b99ef9ae292bc121027463b638cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2908ce2e2ab7703d64a55f3030e2dad19f9a9bc3e768280341dd2e3f06e29fbd"
    sha256 cellar: :any_skip_relocation, sonoma:         "cf93817dd555238be7ad1a45d3dd771d69c529eac958abe836fc2109eb921662"
    sha256 cellar: :any_skip_relocation, ventura:        "70bd562414f356c6709cfe38547cc71dae94ff76c8880c6f8b59b57caffa25b3"
    sha256 cellar: :any_skip_relocation, monterey:       "a3f15f4379a00bdc9f6cda380414e2b234635797e7a38b9f04bc9edba8293514"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b784426a7442b4752498b66324497a9dcd087b9354e1df5ee6d507fba0a5d8a6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "jaq")
  end

  test do
    assert_match "1", shell_output("echo '{\"a\": 1, \"b\": 2}' | #{bin}/jaq '.a'")
    assert_match "2.5", shell_output("echo '1 2 3 4' | #{bin}/jaq -s 'add / length'")
  end
end
