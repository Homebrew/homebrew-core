class Miller < Formula
  desc "Like sed, awk, cut, join & sort for name-indexed data such as CSV"
  homepage "https://github.com/johnkerl/miller"
  url "https://github.com/johnkerl/miller/releases/download/v6.23.0/miller-6.23.0.tar.gz"
  sha256 "855b5c32798dffacc83f2c8da74abd1e9318571f8944c669e4003b5e2662a7e5"
  license "BSD-2-Clause"
  head "https://github.com/johnkerl/miller.git", branch: "main"

  bottle do
    manifest_sha256 "097a59a00486b9116b162ad93a79593ff704b201407feb7676edb7b459b1333f"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "169541ec5cceaab8742963676b197d3ce29a6a685b0cf402756d086a16a11862"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3a428edf572f2a8f7770c5faf701a9d4eef7cecc34d28057c2988703284f860d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4c9976793042d02cf9bb39562c07120eca9042371a2f73325abc90d8fe2ba1f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "afc0feb341ba1855fc9243e513d5510659221488b292e554e5dc2d07004ce1b2"
    sha256 cellar: :any,                 x86_64_linux:      "6dd7883cb79cfed152e70ee907473aa9d92b4c352ed240a6464f25cce47361fc"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
