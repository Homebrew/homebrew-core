class Miller < Formula
  desc "Like sed, awk, cut, join & sort for name-indexed data such as CSV"
  homepage "https://github.com/johnkerl/miller"
  url "https://github.com/johnkerl/miller/releases/download/v6.6.0/miller-6.6.0.tar.gz"
  sha256 "943616a95989fbb8ea7ca47625391b8a86fd009a041eff3636e50443fea05406"
  license "BSD-2-Clause"
  head "https://github.com/johnkerl/miller.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3afc7891143e22c593ec5e4ef175cefc4ef0db4d7bf0a4bbe1511b1e0a7949cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4393e4ce4de6efcc524c82d1f8c268ba39248049791647d1f4167c8d563ecdb9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3319c03ea55df7e7ff479c69321231d04b02c59a65413c6d0531921657d787f1"
    sha256 cellar: :any_skip_relocation, ventura:        "ab0d54332443160bfee6d203034ce61cab506ec5a7bbab4757335f1eb0aa0465"
    sha256 cellar: :any_skip_relocation, monterey:       "7324df686c39375d013806d8b25d52a36fad492eee6c9890bc69b5be9b43905d"
    sha256 cellar: :any_skip_relocation, big_sur:        "ac539d4b131fb13b8228e41b42c6d353b7c41cb31828f7b04c087ad5b7fdfd51"
    sha256 cellar: :any_skip_relocation, catalina:       "100d297cae7f388856ad7c511d004d5ddf82b18944c53f936b2afe4dace0087b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78defeda11d9dfa01b996acfd5824ccfb835e055f934b27a7bf1ab88b7b9eb14"
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
