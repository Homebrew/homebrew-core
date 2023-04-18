class Cgrep < Formula
  desc "Context-aware grep for source code"
  homepage "https://github.com/awgn/cgrep"
  url "https://github.com/awgn/cgrep/archive/v7.0.0.tar.gz"
  sha256 "87c596447882b3acf0a754ac52ac1b5314961e652708a25ffc49ec5977b1f11a"
  license "GPL-2.0-or-later"
  head "https://github.com/awgn/cgrep.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e17cbf5d7586ca6412b44e1ff1a83a944fc445bddad20292a92592d981bc41ab"
    sha256 cellar: :any,                 arm64_monterey: "2655867717a9a2bc1db99c238a0a0d20794266480058a8e559fa97c40931b9f5"
    sha256 cellar: :any,                 arm64_big_sur:  "6f559f1d9f6200d473916385605b98df079ff0a73f20c72c88fa5da0daff2e32"
    sha256 cellar: :any,                 ventura:        "029ac12193d1a6b4435af4fae22a11c36c160ddeb78ab7fb0d1813972fe7362b"
    sha256 cellar: :any,                 monterey:       "a9b7915b8f024de06e3112954f71da9b833e4bce365985c323128ff5f7c5c3f9"
    sha256 cellar: :any,                 big_sur:        "da78325ef5883b34580775cb8edbebcca3eb587631744e9d0edbd8381a9552a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f5f2576e078a73d016397fffc8f26a8c1aafc176286bf885e16cee0f37b6abe"
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
