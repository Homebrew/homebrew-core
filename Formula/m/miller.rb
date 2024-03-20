class Miller < Formula
  desc "Like sed, awk, cut, join & sort for name-indexed data such as CSV"
  homepage "https://github.com/johnkerl/miller"
  url "https://github.com/johnkerl/miller/archive/refs/tags/v6.12.0.tar.gz"
  sha256 "e97dab1a514ecd88da9374b2a5759cebc607476596f6b1d6d8fbe444b9e0eab2"
  license "BSD-2-Clause"
  head "https://github.com/johnkerl/miller.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "41d165628034e98e790e1278f1e580fdc459c9569aa32707ccae50181420c031"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "31f74d6ce36b939e7af50c426957fe9643d8ea7c5428ffea70fa7caa75b5ce06"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b860d5ac94d3a3d5ed24c4e9e02f6767a069ea022d3e7cccc0a024396c32270a"
    sha256 cellar: :any_skip_relocation, sonoma:         "a27b3626056fb33840ef9da328f234653532db44115db56dfaa66d2773cc6778"
    sha256 cellar: :any_skip_relocation, ventura:        "e40f7e0adff847e2d17318f0aeceaec52936b89b51845c7f2a9dbdcb980fc095"
    sha256 cellar: :any_skip_relocation, monterey:       "1f18150db9d42cf11a12054479e83178cc6cb3df29dc5eded5cfaa5730d88c9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0febf0d69cc90f68b939a40ded6fa07ac67613dbbf7284aa0257e5244263771"
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
