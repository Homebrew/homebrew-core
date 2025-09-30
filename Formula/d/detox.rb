class Detox < Formula
  desc "Utility to replace problematic characters in filenames"
  homepage "https://detox.sourceforge.net/"
  url "https://github.com/dharple/detox/archive/refs/tags/v3.0.1.tar.gz"
  sha256 "15dc32ca5856a3edc2fff237c8cbcb29979a25292aac738a272181d2152699ea"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_tahoe:   "1f4a2308f134605e6af719dcad7dfcdd2f6ecc048b4c69f65c1b27c6af0a6ffa"
    sha256 arm64_sequoia: "ce9b57a452b95589a2aec98663da824fb08d5336b90e4b0d49929a620cbc1f3b"
    sha256 arm64_sonoma:  "7f8d15ffabb295011c2d6e4e1681196d26b88dc31841787d2fd08a061afe4f47"
    sha256 arm64_ventura: "e38cc831cb81dff39a77a3355a4f91c7fc8e9e896400b0931b4997620a068234"
    sha256 sonoma:        "bfbb8acca19b7f2214f490a072f9bf8157f01cd160d6339aaf6e0935b8cfe519"
    sha256 ventura:       "a7d62b75598031b522a02dbe8c93368751e5cfde317e16ca86305dd2bc506471"
    sha256 arm64_linux:   "5cf76b955859cefac2d10cda631e81c26b519e202f70be163f0c73e52bdac572"
    sha256 x86_64_linux:  "648e5e31695aa59ab1f7bff5524363e84a513c0f07d65050487dd6366002178c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--mandir=#{man}", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"rename this").write "foobar"
    assert_equal "rename this -> rename_this\n", shell_output("#{bin}/detox --dry-run rename\\ this")
  end
end
