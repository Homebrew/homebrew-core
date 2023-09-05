class Miller < Formula
  desc "Like sed, awk, cut, join & sort for name-indexed data such as CSV"
  homepage "https://github.com/johnkerl/miller"
  url "https://github.com/johnkerl/miller/archive/refs/tags/v6.9.0.tar.gz"
  sha256 "e85ce4d7ea2aa7d0986939c64db9eec69f2e1e59a91bbee25d7d1f994543ca60"
  license "BSD-2-Clause"
  head "https://github.com/johnkerl/miller.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "894631be7f24a39276adfe8f5071c35fddfa5c0f1feed0dc4da8d510865b0dbb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f5c62c9055c1aab369b40a66783d271c9afe0371e2719bdc5af2530b6f7dcd2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8302e89879478823af03725278fe389e4ace4490f97428eba97dfa95aae6b955"
    sha256 cellar: :any_skip_relocation, ventura:        "970ae777b22d8a83f5c64b36f127b53282859773684c6a496be03727c214c8dc"
    sha256 cellar: :any_skip_relocation, monterey:       "25674457f02fddac8754a6329006754913d457e1410de64534420caf19b561e0"
    sha256 cellar: :any_skip_relocation, big_sur:        "53b81d510c3e26c84e546bc4a78d7a0a95ab30fe72d47c6bd1e83692b6dedb00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a9dd71ff519c297319dbed8bd3510b7cafa7cda6234f8ffe540f8172b4c5a92"
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
