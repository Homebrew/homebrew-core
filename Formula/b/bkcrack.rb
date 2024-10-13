class Bkcrack < Formula
  desc "Crack legacy zip encryption with Biham and Kocher's known plaintext attack"
  homepage "https://github.com/kimci86/bkcrack"
  url "https://github.com/kimci86/bkcrack/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "6d5f6d4aca155d232d0dd9c33618797c973883a95e078beb92287470101d452f"
  license "Zlib"
  head "https://github.com/kimci86/bkcrack.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "3f05b506112527fded6fdd43f30cbed62ef8332662ff4448a21e973f35e599a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d6812c37b8d2c18ee538ddbf84d2cdbabd2f8afcf460f312a761abb952db769a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c49fc15ecf036a8c3901e9b90e16d3a1cfcc2f2a1e8783e633302651ff8f927e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a43a7c5bf6e2e1fa822fb0bc2ce23f884704a4b593c046266b6ff8b671e2c33"
    sha256 cellar: :any_skip_relocation, sonoma:         "bdd52747bb662d8fae70e1b624d17c596b9dd33b91de8fe4d50dbecdba332d92"
    sha256 cellar: :any_skip_relocation, ventura:        "97ae87104c89c50d0adece9ed9f25044feb4ffdbe0f0cfc182cac0568743160d"
    sha256 cellar: :any_skip_relocation, monterey:       "d544d45ad991a832e62d79cffb55534c8bc341b9b39420f6d196f89be60953c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2919f8bd2c79606833f09788c38ea8629f981ad957871ddce49e9e74e733acd0"
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
