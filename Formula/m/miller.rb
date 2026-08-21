class Miller < Formula
  desc "Like sed, awk, cut, join & sort for name-indexed data such as CSV"
  homepage "https://github.com/johnkerl/miller"
  url "https://github.com/johnkerl/miller/releases/download/v6.21.0/miller-6.21.0.tar.gz"
  sha256 "d05b6edb506c16d448e9c66308b0169c80c93e0f3f2ef6ad248d22520684990f"
  license "BSD-2-Clause"
  head "https://github.com/johnkerl/miller.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3887ac6b342f53eaa8c92f8a51e96e8ffadf3b2df11979e5addb31b5a25a9502"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4be4e1b6ef9dee802b72ba1f397d57bba85e4cdd1f4b9b5d3a2328e206353d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3915388a6c1334b285898a9dff8df2359ecf801baf40027fb67def6de803ccc4"
    sha256 cellar: :any_skip_relocation, sonoma:        "36a9e686fcd4c2f54d604a37fc70316e1800e7b743dc81a4a5a55942da6cf4c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c11495d2c6c448791a7adcdce76482e6d08e6ea7fead526a8edd41a41d34475e"
    sha256 cellar: :any,                 x86_64_linux:  "92472be416628948acb0e2627976a29680d0222b69f4b62f2d673a5395e1a105"
  end

  depends_on "go" => :build

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.csv").write <<~CSV
      a,b,c
      1,2,3
      4,5,6
    CSV
    output = pipe_output("#{bin}/mlr --csvlite cut -f a test.csv")
    assert_match "a\n1\n4\n", output
  end
end
