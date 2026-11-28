class Miller < Formula
  desc "Like sed, awk, cut, join & sort for name-indexed data such as CSV"
  homepage "https://github.com/johnkerl/miller"
  url "https://github.com/johnkerl/miller/releases/download/v6.23.1/miller-6.23.1.tar.gz"
  sha256 "2c0ff011198f5a5a18bfa5b12d0858116bf1d4c20c3c905a2b829f18d19c0989"
  license "BSD-2-Clause"
  head "https://github.com/johnkerl/miller.git", branch: "main"

  bottle do
    manifest_sha256 "be20c22cbbb528638265433f91c0a3666ab33e2189dba255d1c481af14ba6d17"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "68102d60d63dd6811693128cae95162833af3a7b4eff7b709bd787b3a99b71a3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2c39a519197b9dea5b789a1015dfbf8777ef35320a5b64c6b11744828ed3ee69"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "11c432706affa62713242070175d388358ecaaa45611f082b573c27314093edc"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b4ef8d23afc70745d17f233d1f69acabd4503a7fdeb0ed28f766c8cf300d8c76"
    sha256 cellar: :any,                 x86_64_linux:      "459fb5466c9a266e734f082d47682f1e610f2eb241c54ef8f3d868c293dfb16c"
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
