class Bkcrack < Formula
  desc "Crack legacy zip encryption with Biham and Kocher's known plaintext attack"
  homepage "https://github.com/kimci86/bkcrack"
  url "https://github.com/kimci86/bkcrack/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "1ed073f9640baac4ba0156a00359e5a08e784cacd9f7de0bd07e2f49616c7a6a"
  license "Zlib"
  head "https://github.com/kimci86/bkcrack.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1cf8f38ed5f045a6215830602e84b069661264da4cdb2cebafa03049aece3daa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8ccdd54ac621e9de415133a75eb11375ae5109c0b4bab3e093204a8b569042e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "555519835883a84e9db5ee8b3df8129a14c350fadc9e702aa7b5d468e2858747"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e34eec5c871650ccc49dbd2ef379247110072a02792480c177c1960a1de8250"
    sha256 cellar: :any_skip_relocation, ventura:       "83907162b233475143ce2438896568a3ea217ffe51144657665324806eabcbe2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30be411154c4b6f3768156272c3c9df5873d95fe83fce31467a6ef5b3a3dd24e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbbc5a49024a5f69aacff16c41914e828999ab73cda787682dde3443a504dbba"
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
