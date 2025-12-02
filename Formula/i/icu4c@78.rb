class Icu4cAT78 < Formula
  desc "C/C++ and Java libraries for Unicode and globalization"
  homepage "https://icu.unicode.org/home"
  url "https://github.com/unicode-org/icu/releases/download/release-78.1/icu4c-78.1-sources.tgz"
  sha256 "6217f58ca39b23127605cfc6c7e0d3475fe4b0d63157011383d716cb41617886"
  license "ICU"

  # We allow the livecheck to detect new `icu4c` major versions in order to
  # automate version bumps. To make sure PRs are created correctly, we output
  # an error during installation to notify when a new formula is needed.
  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:[.-]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.tr("-", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "21cb6bc12dba28870ae05577dd4b8ec3019e6c2d7d8813518a068deccbff2bd5"
    sha256 cellar: :any,                 arm64_sequoia: "020c5b916bec54ecc4b767886c5077401245cde08ffee81e1d08b393fc907376"
    sha256 cellar: :any,                 arm64_sonoma:  "108f8e427aa09d1f639c1675e5477197f65081e5a9dfa9c3ce3327fa896711ea"
    sha256 cellar: :any,                 sonoma:        "36ae0d43501c1a63baf42bf9574684a3d64b58bcc034f641bcb1b68efac4ff74"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75e1823a9b274e7d97377ee681a6a54509125b3350e060fca17b4bd344f7a10e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74b3f8216aba75f00256dc91e060e2569f65908acbb705a2dd8f61af4022da1b"
  end

  keg_only :shadowed_by_macos, "macOS provides libicucore.dylib (but nothing else)"

  def install
    odie "Major version bumps need a new formula!" if version.major.to_s != name[/@(\d+)$/, 1]

    args = %w[
      --disable-samples
      --disable-tests
      --enable-static
      --with-library-bits=64
    ]

    cd "source" do
      system "./configure", *args, *std_configure_args
      system "make"
      system "make", "install"
    end
  end

  test do
    if File.exist? "/usr/share/dict/words"
      system bin/"gendict", "--uchars", "/usr/share/dict/words", "dict"
    else
      (testpath/"hello").write "hello\nworld\n"
      system bin/"gendict", "--uchars", "hello", "dict"
    end
  end
end
