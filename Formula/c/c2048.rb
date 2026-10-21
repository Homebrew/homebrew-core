class C2048 < Formula
  desc "Console version of 2048"
  homepage "https://github.com/mevdschee/2048.c"
  url "https://github.com/mevdschee/2048.c/archive/refs/tags/v1.0.5.tar.gz"
  sha256 "83b9008dc77d7ab2ad721d7316551fb015dce97c40337a354040fe45d8296fd4"
  license "MIT"
  head "https://github.com/mevdschee/2048.c.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "34d1b744f2e83653e15e47921aab9b516f010678e52b5e95b8d7b8d66c5769a5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7e2167cada11507d11613f88ff12ece3ef94c4a798e57f758c47fb719257c18a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "18e9b337d2b521fb6d57a1dec101bf9f68f22e1fd188a1a3f2be1a853b6e2b98"
    sha256 cellar: :any,                 arm64_linux:       "41dd2678b0a9d85a7b54383c9ce8b2a4628875995430043691bf82f6d4265593"
    sha256 cellar: :any,                 x86_64_linux:      "8f1a701fa1daba5eae8995d86cd031f78e59d7a65667220b6e29c559a0fd20ec"
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    output = shell_output("#{bin}/2048 test")
    assert_match "All 13 tests executed successfully", output
  end
end
