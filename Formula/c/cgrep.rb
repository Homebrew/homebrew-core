class Cgrep < Formula
  desc "Context-aware grep for source code"
  homepage "https://github.com/awgn/cgrep"
  url "https://github.com/awgn/cgrep/archive/v8.1.0.tar.gz"
  sha256 "029eec8f0339e79eb9d9e92935e5fcf03a40180cb1adfa8784fa4bf3fee11dac"
  license "GPL-2.0-or-later"
  head "https://github.com/awgn/cgrep.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1be4666dae6c73bf8266fb23aecebffe4b9ee7683f37571cfaead814984ff4e4"
    sha256 cellar: :any,                 arm64_monterey: "259521bed3744ab359046cd17f61bb2bfacf32e9a11a82908b0bfdd3fdc67391"
    sha256 cellar: :any,                 arm64_big_sur:  "a213ca116fa7f00535a4569bc19ad9174ac2d43074386af5ac39d0f114b42fd0"
    sha256 cellar: :any,                 ventura:        "802fbd7f2a47c416cf5ec1d2edcaaffb3b903570b9950deebd1381c9530bbd3b"
    sha256 cellar: :any,                 monterey:       "ac64013156a71e7b3e597b42b41e88ed2a035c1c79d5d945ce64cadd8ab93b01"
    sha256 cellar: :any,                 big_sur:        "7c530d952f30e64e4bb5a695f01e7976ea82d5ff4418c9142d7df7fb2d7c0b6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fc65a983cde8ba338d2894fe28a85e2b68500e4b48c35b5156b0d172207bbb8"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pkg-config" => :build
  depends_on "pcre"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    (testpath/"t.rb").write <<~EOS
      # puts test comment.
      puts "test literal."
    EOS

    assert_match ":1", shell_output("#{bin}/cgrep --count --comment test t.rb")
    assert_match ":1", shell_output("#{bin}/cgrep --count --literal test t.rb")
    assert_match ":1", shell_output("#{bin}/cgrep --count --code puts t.rb")
    assert_match ":2", shell_output("#{bin}/cgrep --count puts t.rb")
  end
end
