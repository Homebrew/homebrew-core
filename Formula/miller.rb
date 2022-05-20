class Miller < Formula
  desc "Like sed, awk, cut, join & sort for name-indexed data such as CSV"
  homepage "https://github.com/johnkerl/miller"
  url "https://github.com/johnkerl/miller/releases/download/v6.2.0/miller-6.2.0.tar.gz"
  sha256 "da26531fe9bca1c1917ea41dd1f1d7338c61f50275ad3ea41d3bc4685da34687"
  license "BSD-2-Clause"
  head "https://github.com/johnkerl/miller.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1977b6173f9cc825908d298f16b8a26eab46e394bbccdaf23b1cee94ab1b62f5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "58b751816639241f329df20252c4acaf24df5293296ef2149753b2633765116e"
    sha256 cellar: :any_skip_relocation, monterey:       "431da10bb1143add10132eb5a033f5ac75e554b097294a7717e8b5bba71aaccb"
    sha256 cellar: :any_skip_relocation, big_sur:        "15fda6eeac690a33c7ed80f841861c7ac6fb16b12244079e8257bf70771e4c67"
    sha256 cellar: :any_skip_relocation, catalina:       "a1df60ba5a5b9227490ecd0fb1b1bdbd5042fdbf52d97f2ebfcb30d391b5007c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a217a9914c35405facc39fff757eb36d129b60dafed198eaeb7f2a7a29aa45b8"
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
