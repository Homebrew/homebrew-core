class Miller < Formula
  desc "Like sed, awk, cut, join & sort for name-indexed data such as CSV"
  homepage "https://github.com/johnkerl/miller"
  url "https://github.com/johnkerl/miller/archive/refs/tags/v6.16.0.tar.gz"
  sha256 "6b18ae38b9943942ad4c196b183a9b782ebd66bde1eb3f4528f8c81137f7a0db"
  license "BSD-2-Clause"
  head "https://github.com/johnkerl/miller.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8cdaa7bc1dd06589bbe4aaa007a81ac48f8d4a745baaf8032e9897d2016c8a86"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd59d1e02a892132de3cf72ed3025731eab94529ce25475175c0dbbf8a4d0c11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c94224782752394a904a9eb248d31e397b863bf8217b5488a4b5c743ea6ce69"
    sha256 cellar: :any_skip_relocation, sonoma:        "7276cf06d6df338be11af7304cf3501bb2b6f46fa16a5358f6a8668105f3976e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc92d9978a969c6b6beae0a35908fe38bee64a549e7db3fa0340eb1f8e77d5fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "257ebbc7ca204bb42939e55e3c826ad97e07f2adf1ff186eb879f985dd255ccc"
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
