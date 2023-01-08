class Fend < Formula
  desc "Arbitrary-precision unit-aware calculator"
  homepage "https://printfn.github.io/fend"
  url "https://github.com/printfn/fend/archive/refs/tags/v1.1.4.tar.gz"
  sha256 "6343013cedfb4000e9415b64f9f98f365c96d0c2186f912d562d4fc752a21207"
  license "MIT"
  head "https://github.com/printfn/fend.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c7e68f999804fd7f7d2803df96a196c533e61d7a9efbb809b73cefed629d16f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15618930db2981a714b233b010c395bfed2f770f1937275fb3489bbaf11dba8c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9f47ceaa72e96fb5ecfefc9eeedcc13b903e557d507d4e588920c72503712710"
    sha256 cellar: :any_skip_relocation, ventura:        "8f246377f4119cba1b55875724f4b7a09e8589b805a005d1753568accd5c8caa"
    sha256 cellar: :any_skip_relocation, monterey:       "946abf04eb2ff81a2b744becba1118d30b14f70b6dd76da4c429578298ff4395"
    sha256 cellar: :any_skip_relocation, big_sur:        "3a5d541d5e687c263f54789bccabc629718fdcab7e0e3bb8c7bd690db68a6700"
    sha256 cellar: :any_skip_relocation, catalina:       "12dd063157e268b64974d02a866ea3f9febfea4d6bf729afa6f774b5f9bee5f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "efc90470e24cb76c52263588d43291efbb2e63e60a4fc458f9f75b3d6ca8c55a"
  end

  depends_on "pandoc" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
    system "./documentation/build.sh"
    man1.install "documentation/fend.1"
  end

  test do
    assert_equal "1000 m", shell_output("#{bin}/fend 1 km to m").strip
  end
end
