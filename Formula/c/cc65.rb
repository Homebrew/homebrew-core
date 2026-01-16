class Cc65 < Formula
  desc "6502 C compiler"
  homepage "https://cc65.github.io/cc65/"
  url "https://github.com/cc65/cc65/archive/refs/tags/V2.19.tar.gz"
  sha256 "157b8051aed7f534e5093471e734e7a95e509c577324099c3c81324ed9d0de77"
  license "Zlib"
  head "https://github.com/cc65/cc65.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "f920a8752f63358eadceb552629837af0fe7e35461c0d98c0430ede6cda0a4c5"
    sha256 arm64_sequoia:  "55807c89176cd3d4570b3728a7fabf1ac2c7014d11f6aec4ca5ed7fdd58c364b"
    sha256 arm64_sonoma:   "41632cc243d34d069cc66bd938aaa297265ab1f5438c59bfef49d8c49965c0a2"
    sha256 arm64_ventura:  "753141cb314e207064134c09d9f31ce82f9d2ca720925f321cb81100ef3ee347"
    sha256 arm64_monterey: "9353c4052546b46967c63aabc48e64633164669129e6406f8afc2dcaac17fb89"
    sha256 arm64_big_sur:  "47405e34cd591b17d9ed65842f25ac7c6d9f61e98f21b9c403596257d7e23dae"
    sha256 sonoma:         "f253df296eb1aeb17bc02fef52e836d45b77b3364337abf68d53d26cbda218a5"
    sha256 ventura:        "18dc69ba26b9bee5ef93a34ec4e38111c7cf6c8fe0d4fdee174ed9980718e66e"
    sha256 monterey:       "2598003d7c24868193167d8095f1c4c22a4f46627073e480dbf7c67bba340ce3"
    sha256 big_sur:        "d0010fe7f4b58daea95dd57f4116668bd2bedfbd5392e73412162292034d456d"
    sha256 catalina:       "a773d68d33b81899ebe7c10d294c0d6e2c2eab9063206f787b1e8c5b8e36f437"
    sha256 arm64_linux:    "668380deeb544b5843f43f62f70d7d8acf4e25063764429c77a5ebc276a49ce0"
    sha256 x86_64_linux:   "a07773f9ba0bcbe345f8e3c27495b9f149ff0a4df6245748cb8152a75b13880f"
  end

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  def caveats
    <<~EOS
      Library files have been installed to:
        #{pkgshare}
    EOS
  end

  test do
    (testpath/"foo.c").write "int main (void) { return 0; }"

    system bin/"cl65", "foo.c" # compile and link
    assert_path_exists testpath/"foo" # binary
  end
end
