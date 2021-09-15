class Cgrep < Formula
  desc "Context-aware grep for source code"
  homepage "https://github.com/awgn/cgrep"
  url "https://github.com/awgn/cgrep/archive/v6.6.33.tar.gz"
  sha256 "f0d7114e9c26dc3ff3515711cce63864f3995ac06ed3743acf2560fc5a1eb78e"
  license "GPL-2.0-or-later"
  head "https://github.com/awgn/cgrep.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_big_sur: "fad4cc03f990a4aa7488d89f306766e5a496adc92431c5b5de80e0f8c4d33a73"
    sha256 cellar: :any,                 big_sur:       "cdb29911007db234f2480b8f4d7958a024f14d33c219b9de134fcc335d39357a"
    sha256 cellar: :any,                 catalina:      "75e4aa890057e43801be25ca61531c74b22b8685a3ada1032c270b740e9a9cda"
    sha256 cellar: :any,                 mojave:        "83e3c982a030617bc8d4b2dd329170e2c8ad7d77d40f715ecb83f7bdcba86135"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3b1169d4c9e8643d7b613bb7f9b16e7d773d65de726fbac7dc85323580b2f06"
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
