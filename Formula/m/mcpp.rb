class Mcpp < Formula
  desc "Alternative C/C++ preprocessor"
  homepage "https://mcpp.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/mcpp/mcpp/V.2.7.2/mcpp-2.7.2.tar.gz"
  sha256 "3b9b4421888519876c4fc68ade324a3bbd81ceeb7092ecdbbc2055099fcb8864"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(%r{url=.*?/mcpp[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "f3678576a7e9a2007227897d1617aba79b3ace1340c0a5e77b1bcfff43da38c3"
    sha256 cellar: :any,                 arm64_sequoia:  "37f98fe44da635f01775091f8196d3eacb4b9dfcab22b5702488714ea4599cba"
    sha256 cellar: :any,                 arm64_sonoma:   "42c256dc7e6f9d09f12de8bf97cc1988d020931cc7471c8ae9402b35d57748f7"
    sha256 cellar: :any,                 arm64_ventura:  "1c08275021d44b1db481d2f802ce2b69da952ea4afe04e1a0ce9ae36243f08f1"
    sha256 cellar: :any,                 arm64_monterey: "506e27459d6f4f9fc296bcf826d113aaa659fc814f11419fa484bf38ec94888d"
    sha256 cellar: :any,                 arm64_big_sur:  "b6b90e4e5f4b50a390a5cbd6d2c6664dd8d3212013e469c9d3c90d5bf67a774c"
    sha256 cellar: :any,                 sonoma:         "94b52de3f8d1a6023e83f10cb82fd00d8c3284a971b6f04ae48d8f0584180971"
    sha256 cellar: :any,                 ventura:        "69aad3cd745bb5fb369475a44ac532848d2cedee77a832552cff37f522b19469"
    sha256 cellar: :any,                 monterey:       "fb4dbfea519b3df6d1b10a769ac1f25f53fccda42d2112602a9dcd2eee7bd791"
    sha256 cellar: :any,                 big_sur:        "ba1468299782ecb1de53cff2390096e7300f5c8f021cef623544d969a37240df"
    sha256 cellar: :any,                 catalina:       "742a861cb7087caedaed90aa40c4780a1e6e4ad50be74ee64b251c6ae1ebe21c"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "e3b5ff7ba12b3476bfdbc98e83a6aefb67ccee2a96201ac521baa85389585e73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7869ff9d2c9946dd38a7891ea70766983208df755ca0f206016211b3239701c8"
  end

  # stpcpy is a macro on macOS; trying to define it as an extern is invalid.
  # Patch from ZeroC fixing EOL comment parsing
  # https://forums.zeroc.com/discussion/5445/mishap-in-slice-compilers
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/mcpp/2.7.2.patch"
    sha256 "4bc6a6bd70b67cb78fc48d878cd264b32d7bd0b1ad9705563320d81d5f1abb71"
  end

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    # expand.c:713:21: error: assignment to 'char *' from
    # incompatible pointer type 'LOCATION *' {aka 'struct location *'}
    ENV.append_to_cflags "-Wno-error=incompatible-pointer-types"

    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", "--enable-mcpplib", *args, *std_configure_args
    system "make", "install"
  end

  test do
    # fix `warning: Unknown encoding: C.utf8`
    ENV["LC_ALL"] = "en_US.UTF-8"

    (testpath/"test.c.in").write <<~C
      #define RET 5
      int main() { return RET; }
    C

    (testpath/"test.c").write shell_output("#{bin}/mcpp test.c.in")
    system ENV.cc, "test.c", "-o", "test"
    assert_empty shell_output("./test", 5)
  end
end
