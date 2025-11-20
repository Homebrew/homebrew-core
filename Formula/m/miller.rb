class Miller < Formula
  desc "Like sed, awk, cut, join & sort for name-indexed data such as CSV"
  homepage "https://github.com/johnkerl/miller"
  url "https://github.com/johnkerl/miller/archive/refs/tags/v6.15.0.tar.gz"
  sha256 "91f1cbb91db6b6f93f0b582b73fede6659e37a730d8f30f7bb5e0ce5c356f63d"
  license "BSD-2-Clause"
  head "https://github.com/johnkerl/miller.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de1a6bd44d64874cbc2a53befe4283cd173bf35012a084bdf217515ac6aa2415"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b008968b4fc8b89b7fabf6964c89c2775ecb646d022baa9d2614069fce6e2a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3eae445bf047028a0033819c3d0a588579b194cdf23e472b372010fcce77c82"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e6504b651c26a492d62230e6c09532202e5c32df554cae00271b48eb3f52f7f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee42004b75cd2da7573aad293dc14ae589600d069fc7e3838405f1623c5bc14d"
    sha256 cellar: :any_skip_relocation, ventura:       "2895f2675b024752364186edf3af51e5f99c89c0d6b239df445223773c8f89d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26f0467141b454008af70b577e31e2b7a95a7f3a998c0a0d1d646655b6053057"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0aa560465b9b2d0795ce24407319672b73be87b51035f4857254cb4ccea72d8a"
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
