class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.26.0.tar.gz"
  sha256 "7c7bafc3ad8ca4507835cfdd503e8ad06ad347a3815de0a7300280ee597f278a"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "49fda5fd3f320428aad66c779a4a84d8ebbc8ce481261e44cf372d91f972300b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7bf718ae5c06e2353fe5903d2181075488794ccd08009ed7e1854e398bb6f474"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6d7e1f10518c4b8ece58974ec93efea807818070a3ce4925e6b230825ae54a71"
    sha256 cellar: :any_skip_relocation, ventura:        "7ebfc6e254ae1d405788d2d9dc4148fe0320f187786e96e3628550fbe20b9fa0"
    sha256 cellar: :any_skip_relocation, monterey:       "30a663b3c3b1ac75b935fd089f2184bbd21637befd6f31a46b7f3f8879042c81"
    sha256 cellar: :any_skip_relocation, big_sur:        "0c0b79185d347af93519d6c186506a3768c81bd156d09c2a6a9576e975a084b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1742ef1862eae0b76ab292cb1656de931697e0fdce6880a5906f41786f24cb3d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "httm.1"
  end

  test do
    touch testpath/"foo"
    assert_equal "Error: httm could not find any valid datasets on the system.",
      shell_output("#{bin}/httm #{testpath}/foo 2>&1", 1).strip
    assert_equal "httm #{version}", shell_output("#{bin}/httm --version").strip
  end
end
