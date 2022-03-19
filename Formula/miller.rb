class Miller < Formula
  desc "Like sed, awk, cut, join & sort for name-indexed data such as CSV"
  homepage "https://github.com/johnkerl/miller"
  url "https://github.com/johnkerl/miller/releases/download/v6.2.0/miller-6.2.0.tar.gz"
  sha256 "da26531fe9bca1c1917ea41dd1f1d7338c61f50275ad3ea41d3bc4685da34687"
  license "BSD-2-Clause"
  head "https://github.com/johnkerl/miller.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fabfdac39358b9289f3ee5a9bba4a9c7bb1c08d25dda2d185be5a31fd293d463"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "88bcb5b59092895020536ae6fa7ce86419880a13ff43ba689e248319de4a4f56"
    sha256 cellar: :any_skip_relocation, monterey:       "6a0c523085b80b7eeba84e9d86eceb4fc8af6f88f711c70b401893f507dd389b"
    sha256 cellar: :any_skip_relocation, big_sur:        "5a964563bf3d81c8bc16fdd42ce09fc68e788d5055133365ec8e66a23f74ffec"
    sha256 cellar: :any_skip_relocation, catalina:       "65e720208f4f4f3888e247db35769bd51ed00a002062d12288f8bf4db3ad16ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c00ca6ea550c64d091eb1fbfadefeb55d579a53cd2ea00476f6bbb5d4b469552"
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
