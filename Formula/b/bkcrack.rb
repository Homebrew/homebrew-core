class Bkcrack < Formula
  desc "Crack legacy zip encryption with Biham and Kocher's known plaintext attack"
  homepage "https://github.com/kimci86/bkcrack"
  url "https://github.com/kimci86/bkcrack/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "bb6a6d0bb1ccbb3c39cf8b3113581b5514b127023bbe0e864992c57e79346053"
  license "Zlib"
  head "https://github.com/kimci86/bkcrack.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f1e3072a7939eced9fa14731cd317886d42495018642b18fa1759efb759de3b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bef4cdf4614b7dee8af98a480523946f4fcc226f513ce1f82878655c05bef0a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "caf161efd7323878ac616aacf0d95865f6f0089ac871f586de8af139c9192f1f"
    sha256 cellar: :any_skip_relocation, sonoma:        "8123340e60ab3ec3f3876831311f1f5f915ac9e1e753cf45ac9a3a8947c89e62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f6437c1bc9e24a70cff2fb2e75e44314f3b4cf17f82880fc1c342ed99f4bf19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b5b5e60a8ab8173b6ac1c6058a39f8cb118e2fc4c1b7de1b9bd896394d1b109"
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
