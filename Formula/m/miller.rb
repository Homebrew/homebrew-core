class Miller < Formula
  desc "Like sed, awk, cut, join & sort for name-indexed data such as CSV"
  homepage "https://github.com/johnkerl/miller"
  url "https://github.com/johnkerl/miller/archive/refs/tags/v6.12.0.tar.gz"
  sha256 "e97dab1a514ecd88da9374b2a5759cebc607476596f6b1d6d8fbe444b9e0eab2"
  license "BSD-2-Clause"
  head "https://github.com/johnkerl/miller.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "67813805eb38c5cd356d01eb6479ec622d6727c1a2ff5ecc740a666d940f7fab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e8b026ce87877e8145ec7484568aea1bebf4fd632a2faaa77a2eda687290bf11"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28bb68eaa5779ec6480d581b9aa5efd109f6f3a0e5d2126e36f3220d5c4c89ec"
    sha256 cellar: :any_skip_relocation, sonoma:         "aedf19321800579b323902a37b5b63c375945b5d16d47b6d454ffc7c3e1d85d0"
    sha256 cellar: :any_skip_relocation, ventura:        "5e2429253c23448844578c3915554da59746c1374eed0b6329b4279fa9da4c5f"
    sha256 cellar: :any_skip_relocation, monterey:       "4ab9d095f213e22ae9e96309fb6bc0ed2a6006f65adbba20d2d458ecd55d05a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b21d8681281339a5ad2c97e691a44d924b14eed4fbb36a90a01092af64260cc5"
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
