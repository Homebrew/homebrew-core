class Oggz < Formula
  desc "Command-line tool for manipulating Ogg files"
  homepage "https://www.xiph.org/oggz/"
  url "https://ftp.osuosl.org/pub/xiph/releases/liboggz/liboggz-1.1.3.tar.gz"
  mirror "https://ftp-chi.osuosl.org/pub/xiph/releases/liboggz/liboggz-1.1.3.tar.gz"
  sha256 "2466d03b67ef0bcba0e10fb352d1a9ffd9f96911657abce3cbb6ba429c656e2f"
  license "BSD-3-Clause"

  livecheck do
    url "https://ftp.osuosl.org/pub/xiph/releases/liboggz/?C=M&O=D"
    regex(%r{href=(?:["']?|.*?/)liboggz[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "603716b336363c7460ee420337b0de8c0577261236bb6f464b95442f634c103c"
    sha256 cellar: :any,                 arm64_sequoia: "662621ea7c3e2bba651d8a4d58de1b7e11fe77457919bec4a1a891344a9fa52b"
    sha256 cellar: :any,                 arm64_sonoma:  "b73a313c07c02a73751ff8837ff86eee990bb438c7391f3ef401ad7252a1b2fc"
    sha256 cellar: :any,                 arm64_ventura: "574236c1d041249054c6767741940b013cebc9771ca97108fbab98973d4b5898"
    sha256 cellar: :any,                 sonoma:        "5d24d31ff9a43ff9889dea391bb86e16016efec62385d0b17e8648d0242e3bd1"
    sha256 cellar: :any,                 ventura:       "734cb42ad73f66af33c147440e1af89b3a3e1f508dbb902e12f9ab164e252aba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38b2592995a25f2e1024b80fce55beed16e179fa53ee4306671e61f9b6624ec4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad3472b35ebd01c5335c7557dd3274fd27d365e09722e0beed0749e0e47c28cb"
  end

  depends_on "pkgconf" => :build
  depends_on "libogg"

  # build patch to include `<inttypes.h>` to fix missing printf format macros
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/liboggz/1.1.2-inttypes.patch"
    sha256 "0ec758ab05982dc302592f3b328a7b7c47e60672ef7da1133bcbebc4413a20a3"
  end

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"oggz", "known-codecs"
  end
end
