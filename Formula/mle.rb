class Mle < Formula
  desc "Flexible terminal-based text editor"
  homepage "https://github.com/adsr/mle"
  url "https://github.com/adsr/mle/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "569316485fa3775d0bb7559ac176a63adb29467c7098b14c0072c821feb6226b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e220e1bc7b95b0b716fcad8c8e3db661bf9f191f44af78c7b450906d6c605316"
    sha256 cellar: :any,                 arm64_monterey: "01678f6f819e2caaa4739e9c0d00b52a3c9c5229ba834c0e498b7b0e790e63d5"
    sha256 cellar: :any,                 arm64_big_sur:  "fd31fe9d1e34cbed3c01748bf0e874f9094159ad68c13be97605171f52311d97"
    sha256 cellar: :any,                 ventura:        "91c633473d9937df89dcf08965dc3381bac95e549ce7747c10fba2b815307ca5"
    sha256 cellar: :any,                 monterey:       "313e12d493c3ae1a1093d7cfe59c96c644555a85032a999553c31250e4a7be61"
    sha256 cellar: :any,                 big_sur:        "b66e997509ab41cbf2031e6deab8a1df2fb5a9c31c3276480966300e63535b9e"
    sha256 cellar: :any,                 catalina:       "87f1b28bd92f3deb1ae274486faf19dca29593b1168efbed9522628c6d186c43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d60127a0f3de29ddcaed1c0da64c1ca6747013db10fdb59c5041cb778cee596"
  end

  depends_on "uthash" => :build
  depends_on "lua"
  depends_on "pcre"

  def install
    # TUI hangs on macOS due to https://github.com/adsr/mle/issues/71
    # Fix implemented upstream, extra flag should not be needed on next release
    ENV.append_to_cflags "-DTB_OPT_SELECT" if OS.mac?

    system "make", "install", "prefix=#{prefix}"
  end

  test do
    output = pipe_output("#{bin}/mle -M 'test C-e space w o r l d enter' -p test", "hello")
    assert_equal "hello world\n", output
  end
end
