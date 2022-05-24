class Clucene < Formula
  desc "C++ port of Lucene: high-performance, full-featured text search engine"
  homepage "https://clucene.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/clucene/clucene-core-unstable/2.3/clucene-core-2.3.3.4.tar.gz"
  sha256 "ddfdc433dd8ad31b5c5819cc4404a8d2127472a3b720d3e744e8c51d79732eab"
  head "https://git.code.sf.net/p/clucene/code.git", branch: "master"

  livecheck do
    url :stable
    regex(/url=.*?clucene-core[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 monterey:     "c557e0403dce15f14e8584b4542fbe6dbd7ddc467d085d99e396b3fd16651dcb"
    sha256 cellar: :any,                 big_sur:      "22366684958d7ee8fd5d0b07efe750a74347a4394dbc56ea80db1cf25db70c2f"
    sha256 cellar: :any,                 catalina:     "c5b00eb94db40324fb66bc7f79737f3963ea5f0df6f7c07c39583fe95bfe0ae6"
    sha256 cellar: :any,                 mojave:       "1e19a680030d8c4863deb4d5a5bc40675c58df5c21e5e7217f2ed8fcbc624d21"
    sha256 cellar: :any,                 high_sierra:  "3986feb447660b2732e2983f54d22086b10da442cb2d7b6ceac45a91ad58f09b"
    sha256 cellar: :any,                 sierra:       "5d25768dc355533553e6c1605a1dc89985ddd26b4d17d10078c39d6b085c03fb"
    sha256 cellar: :any,                 el_capitan:   "5ee0c98072c18c75dd8c25fd309ccb49f033300d474367a8e325ec601c427f66"
    sha256 cellar: :any,                 yosemite:     "182db4f73e058e9d28b77cbbd642c40ecc403fbf1d9dc8357387b2c54dba8d1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4c61f6b320d11670d29ae7294ede5bcd3c1d5684c41cc01ed689de688dbab6e7"
  end

  depends_on "cmake" => :build
  uses_from_macos "zlib"

  # Portability fixes for 10.9+
  # Upstream ticket: https://sourceforge.net/p/clucene/bugs/219/
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/ec8d133/clucene/patch-src-shared-CLucene-LuceneThreads.h.diff"
    sha256 "42cb23fa6bd66ca8ea1d83a57a650f71e0ad3d827f5d74837b70f7f72b03b490"
  end

  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/ec8d133/clucene/patch-src-shared-CLucene-config-repl_tchar.h.diff"
    sha256 "b7dc735f431df409aac63dcfda9737726999eed4fdae494e9cbc1d3309e196ad"
  end

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end
end
