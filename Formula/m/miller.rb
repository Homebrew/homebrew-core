class Miller < Formula
  desc "Like sed, awk, cut, join & sort for name-indexed data such as CSV"
  homepage "https://github.com/johnkerl/miller"
  url "https://github.com/johnkerl/miller/archive/refs/tags/v6.8.0.tar.gz"
  sha256 "3b87d95a5f9dd51510e0131bd1827110bde6b5904fa58bdaba862d261757c0c1"
  license "BSD-2-Clause"
  head "https://github.com/johnkerl/miller.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "012ceebc5f169ed8632a368f88d14d9e4fb517a4ded9713d343e339aaa5cbe50"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc8919f56823e42c553f731b6c549b40253c9480c30cebfca4725242964c320c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c3fbbb0e7e0918a1b6343a81eba5e4aa133285dbff856456181de581206456d4"
    sha256 cellar: :any_skip_relocation, ventura:        "61b2793eed5cb39a083feb12c3030caab141ba0cc47d68922a4e0238f7f4f724"
    sha256 cellar: :any_skip_relocation, monterey:       "4dea05c74a26e653ffebc24eef37d0433b7276b8fa0c8cd2306a787223fdc7e9"
    sha256 cellar: :any_skip_relocation, big_sur:        "841d02e18dcdc41b0f675d430e53aadd8badf878e293a27a6dc054ad11968f23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aea1fe3db7e419037fd9225aec25d3fe0524c002158bb10f56850cc21b699347"
  end

  depends_on "go" => :build

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.csv").write <<~EOS
      a,b,c
      1,2,3
      4,5,6
    EOS
    output = pipe_output("#{bin}/mlr --csvlite cut -f a test.csv")
    assert_match "a\n1\n4\n", output
  end
end
