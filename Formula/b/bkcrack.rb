class Bkcrack < Formula
  desc "Crack legacy zip encryption with Biham and Kocher's known plaintext attack"
  homepage "https://github.com/kimci86/bkcrack"
  url "https://github.com/kimci86/bkcrack/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "db45ca2b328a6d11ba879137a35cc6672860434d17c9aaec8faca317e5a0ae04"
  license "Zlib"
  head "https://github.com/kimci86/bkcrack.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "89c5ba07c0e195f7c116ad1c2a07e5509eb1ef1e31f1e65ec801b207d94715f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4a31c28bdf29afc7f70ae5a310943754f640413902460e3df23481eff08bcc4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a46f30de08bf5af1af30791c920601b9870c9a8e4930afe140b2517b54cd12b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6ff0fb17764fc575d258f5ebe49c14bf9ece374710a5a0fd13289236df0b89e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "5be95fc8becac2d0e068fe31f216860e57a1bac7e967dc822cf8a647223c2da4"
    sha256 cellar: :any_skip_relocation, ventura:       "42cea7f9d5aa9f4633dc5c76b2afdd665d88fab955871122d0a4763af085382e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5c10e6eb0435f67aa597de91b51eb3d50f2f8e8163a538e9124be4ef6376408"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f052f92b46b6ff10807b38af9fac0880f827160d6fc4b14c2e21a755ebd983a9"
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
