class Bkcrack < Formula
  desc "Crack legacy zip encryption with Biham and Kocher's known plaintext attack"
  homepage "https://github.com/kimci86/bkcrack"
  url "https://github.com/kimci86/bkcrack/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "355da1ef04a34ec830ea8b17365161bb599ef4c389ecdcc4afcf262db1df84bd"
  license "Zlib"
  head "https://github.com/kimci86/bkcrack.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7526120ced1b3e3b38e2259aaf150dc3d206cd011b9478c6a24c98f11e1395bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e65506a11a6d043a37155942ba908af68450db0a40b3889ca46037774891fd5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea4180d64ef255e4441909ecceb25dad32841cb4510c47e9bd40a1d5ed730218"
    sha256 cellar: :any_skip_relocation, sonoma:         "71559ab97fde1687853f8344c6c1c143fa4ea7f7e3ce82ad72ad703bf13e1797"
    sha256 cellar: :any_skip_relocation, ventura:        "d9997398af15cfeb590de5ec4bc746496e2a90c4da9a9cb672684960f02bd072"
    sha256 cellar: :any_skip_relocation, monterey:       "ae7fa22feb2e398170454c8b15beade9c1c80e58220b17a7795e7483ba3ff10b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d268f55fe816d2877926822e5cd4125984392f423d7ba72e78422c0a9dcc2464"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    bin.install "build/src/bkcrack"
    pkgshare.install "example"
  end

  test do
    output = shell_output("#{bin}/bkcrack -L #{pkgshare}/example/secrets.zip")
    assert_match "advice.jpg", output
    assert_match "spiral.svg", output

    assert_match version.to_s, shell_output("#{bin}/bkcrack --help")
  end
end
