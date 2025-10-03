class Jaq < Formula
  desc "JQ clone focussed on correctness, speed, and simplicity"
  homepage "https://github.com/01mf02/jaq"
  url "https://github.com/01mf02/jaq/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "80fae7c5bbbc244580ca77d3e5a4fc6e9c3ea08a5526d562e3c5300edd44fe8b"
  license "MIT"
  head "https://github.com/01mf02/jaq.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4fe530857538d1935dda5d031197c37ce565bca559f5a026bcf796d1349f11b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "163be33daf1542ca414e656156ae824ff0e6418a82e6f2fab3f6889f4655ab49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2174c4c293ac06376aaef7a275978ec88a927c663267e15c0ddfc568bd715c41"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a76b473a3413366cff6f42fc9f1e9d8a6586ad7550e3f5b3096e57f679711530"
    sha256 cellar: :any_skip_relocation, sonoma:        "4588e666fb9a9743daec059325fcdbbc0be6646c4682f1923b84b7ce95b77f9c"
    sha256 cellar: :any_skip_relocation, ventura:       "35ff688ca952fa27a513340de10483c1715d1a58044b054e1273fb9975c60ca4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "93442db0bdf314b8f7b5a490f024c52da3cc12806ad3da07d0bba1e704c1a121"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "563f44eed6ac531021e83c87c879b046086be350f622615c30b1c9814c471dff"
  end

  depends_on "rust" => :build

  conflicts_with "json2tsv", because: "both install `jaq` binaries"

  def install
    system "cargo", "install", *std_cargo_args(path: "jaq")
  end

  test do
    assert_match "1", shell_output("echo '{\"a\": 1, \"b\": 2}' | #{bin}/jaq '.a'")
    assert_match "2.5", shell_output("echo '1 2 3 4' | #{bin}/jaq -s 'add / length'")
  end
end
