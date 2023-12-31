class Miller < Formula
  desc "Like sed, awk, cut, join & sort for name-indexed data such as CSV"
  homepage "https://github.com/johnkerl/miller"
  url "https://github.com/johnkerl/miller/archive/refs/tags/v6.10.0.tar.gz"
  sha256 "a7e0fef83e2f8f5fe3c6fce73766209e8ed4906472f0229cbce0930e1f7c5bad"
  license "BSD-2-Clause"
  head "https://github.com/johnkerl/miller.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "157cdee40d8b93fcdbf5d430067b56327c9f01b3f47b2cc60039b39e30f368b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f64f8df5015e9337bf1a6d75464c15e131755c46edd6325eab8e5f52bd59e0a8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e334a723f5155fba01ca1c8724d77e7ae84312393d7051003f44ea2693aa18fc"
    sha256 cellar: :any_skip_relocation, sonoma:         "b52408bdfc671998b2f6b5007ac37050aff9c0acd6acbaec20f203b500a39d2a"
    sha256 cellar: :any_skip_relocation, ventura:        "71900b8deb39cba606493d691660429167f72cee0c30b30c71389f0fa1d5a7e6"
    sha256 cellar: :any_skip_relocation, monterey:       "8099292e4562cb35ecc24a2db381746ae341d3626825b389a54b5317b79a63fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "301c3d787e2efa90d92ad5bc43e7c6430dc42c46a07c43125c12ffc556197832"
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
