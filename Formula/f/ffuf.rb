class Ffuf < Formula
  desc "Fast web fuzzer written in Go"
  homepage "https://github.com/ffuf/ffuf"
  url "https://github.com/ffuf/ffuf/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "52d3daf5b97528a74b7b3305decd4bb01a553a8f18d39fc107ebc15dc3113de7"
  license "MIT"
  head "https://github.com/ffuf/ffuf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "d2bc7b8fdb6344d572c2370dbd676f178386b1199846f14648e5573a3ddd53d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "1b155bee7a2fb90ad42abeed41a16e2f5bb0dec4fc000d62abc790009785f051"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "65e3716152cf4581edd8886235fbf4901e3491128300c9a8deb643df4d385368"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2718eac14605d5d402e211ef3c6b350a6fd164c2316c5b9f94d3f7aa55f222c7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bfac372c5eba036d336f91dc768754d25883ec774cf7ddb3875a8df436e2b80d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0ddb8d734dc47b5e61e2c4403486cb68fc63abd138f631a0930a0ee6f8a9e94f"
    sha256 cellar: :any_skip_relocation, sonoma:         "78899683a2965f7631a647552bc20b6433d53d52553efe0448f9241193abe71d"
    sha256 cellar: :any_skip_relocation, ventura:        "6d1e47780f04c79704306c5a600adf74442579aeba5c3c160c4b3acd30d22b42"
    sha256 cellar: :any_skip_relocation, monterey:       "f9cf641ec6f9183c259d6224bc198b84edaa956f81de8605e8d32661d79cbcdd"
    sha256 cellar: :any_skip_relocation, big_sur:        "e82ed38ee7f97904e45e8597ccff0b9766265c911f5d392dd172b8fafc1bf205"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "ee13b18573768c12d953a558f62e90fc3aea9d0113fb44528931ccab1e479888"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1fdb75ae3154de6dd3b07350b7934568fbdb9230e563d3d8f79fc1643196be3a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"words.txt").write <<~EOS
      dog
      cat
      horse
      snake
      ape
    EOS

    output = shell_output("#{bin}/ffuf -u https://example.org/FUZZ -w words.txt 2>&1")
    assert_match %r{:: Progress: \[5/5\].*Errors: 0 ::$}, output
  end
end
