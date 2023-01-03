class Miller < Formula
  desc "Like sed, awk, cut, join & sort for name-indexed data such as CSV"
  homepage "https://github.com/johnkerl/miller"
  url "https://github.com/johnkerl/miller/releases/download/v6.6.0/miller-6.6.0.tar.gz"
  sha256 "943616a95989fbb8ea7ca47625391b8a86fd009a041eff3636e50443fea05406"
  license "BSD-2-Clause"
  head "https://github.com/johnkerl/miller.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4f15c667d483806cecf54417a92dba36f531dc890eaaca544a06329fc7d0e54c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f87ee090ffd27b3bd479b7a142f9e1333eca795612218d4b1db6da3cf7817af"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "570d116995e94833b25d0b6368211a07838c9a27ea1a1c30cbc255163853c795"
    sha256 cellar: :any_skip_relocation, ventura:        "6881ed287b53f1d54fa2cab8e8004020e932dd9b6126f76a3ee3772cf069cf34"
    sha256 cellar: :any_skip_relocation, monterey:       "f2b6906eb444901e811b81037bfab8979968ed487b55394f669588af3259aaa6"
    sha256 cellar: :any_skip_relocation, big_sur:        "623e34e534c169c5dd6027f04cf94be23d0c64757c3aeb70e78f212543ff37ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b3fdba4b4017fe7ea97dce4377c5cf8ff1d94262b753cfe70a099324b5edeb5"
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
