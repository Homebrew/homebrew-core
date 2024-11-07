class Miller < Formula
  desc "Like sed, awk, cut, join & sort for name-indexed data such as CSV"
  homepage "https://github.com/johnkerl/miller"
  url "https://github.com/johnkerl/miller/archive/refs/tags/v6.13.0.tar.gz"
  sha256 "6beca48af3066fc8d87c3ce17c5dd3debac61ff8f296c0e95c0634fd3ab05599"
  license "BSD-2-Clause"
  head "https://github.com/johnkerl/miller.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09b57aa36476019c512c15cd66d8cc080e5f219ff1acc83eeb52bcb166b776c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11dee02cb195a2b70c76d71f718007093b3c115b48bde88a910578fd17f964d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7f604a40e7a20e6150d5abbc6d5a6c654dab3dbcef141027208b2e4c7da457e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "c37ec76071260833d18befdfeeeaaf4162386c0c25477346c8b6a64f4bedc296"
    sha256 cellar: :any_skip_relocation, ventura:       "1781bcd50d09557818dd14aab3f1b51d0aa328c08a9495236e676205ebabc158"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5fbf792b92ccb4015c4fe4ad2581f81a0cc4d8e110d76ccbd149d02e57f96255"
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
