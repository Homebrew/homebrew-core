class Miller < Formula
  desc "Like sed, awk, cut, join & sort for name-indexed data such as CSV"
  homepage "https://github.com/johnkerl/miller"
  url "https://github.com/johnkerl/miller/releases/download/v6.1.0/miller-6.1.0.tar.gz"
  sha256 "b3a10f0b6984a5b96092cb876f531e83ded013555ede6db4a55614a41245d0ec"
  license "BSD-2-Clause"
  head "https://github.com/johnkerl/miller.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35d1a07fa389108687e94bdbdbf118ef035a1ce50d790093e7c0d456027eb737"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bb7af9ece44ec5318f0586f8969092c26b63f96ef73aa6a3e07458aac476e73d"
    sha256 cellar: :any_skip_relocation, monterey:       "dc0360836c924ea0ecbe28e3f0bfdf46972fab1e1e4eef441540c0c43e236b62"
    sha256 cellar: :any_skip_relocation, big_sur:        "6e85efa4a86dbd85b61ea43fe3b40c276391844f7ea850bbbaa2274bf4fa60ca"
    sha256 cellar: :any_skip_relocation, catalina:       "734413718401968d16fd917f1e4a99d837686980b8fee2d580624e9569d4b3b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0420b1651e32d2aa129e7a9d61afd98b54beb24d0a20910315fb0ec4eacb5cb"
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
