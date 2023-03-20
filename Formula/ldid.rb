class Ldid < Formula
  desc "Lets you manipulate the signature block in a Mach-O binary"
  homepage "https://cydia.saurik.com/info/ldid/"
  url "https://git.saurik.com/ldid.git",
      tag:      "v2.1.5",
      revision: "a23f0faadd29ec00a6b7fb2498c3d15af15a7100"
  license "AGPL-3.0-or-later"
  head "https://git.saurik.com/ldid.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "f59786f3fff036564365d4ed4a8b41d4402bccbbbfa3162ae994bec1796ab3ef"
    sha256 cellar: :any,                 arm64_monterey: "047e835731b086550a69c187b4705b3d746ea1cf813f63a804a87fa1c4c7f45a"
    sha256 cellar: :any,                 arm64_big_sur:  "c81a69241a7bdea0eacd718bd1dbd473607224f38600f043d73be3641ece8cca"
    sha256 cellar: :any,                 ventura:        "313f9431728e3b2f0ad61e12941447cadc3bb84ba1369c6cc6b01334420276b5"
    sha256 cellar: :any,                 monterey:       "35aa6c645ea6b89a1745a636c2710e2638f88edc0ad097e38f09e3f7e9c20c6a"
    sha256 cellar: :any,                 big_sur:        "b75d803f0c93a89a51d9a40d7e6184e4085fe31e5eb5e8b50c11735e9660903c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "016c453d56d1bf999650f1fe6c86b6a06affe7e64bb5e22c187b69e0a0fb11a5"
  end

  depends_on "libplist"
  depends_on "openssl@3"
  uses_from_macos "libxml2"

  def install
    ENV.append_to_cflags "-I."
    ENV.append "CXXFLAGS", "-std=c++11"
    linker_flags = %w[lookup2.o -lcrypto -lplist-2.0 -lxml2]
    linker_flags += %w[-framework CoreFoundation -framework Security] if OS.mac?

    system "make", "lookup2.o"
    system "make", "ldid", "LDLIBS=#{linker_flags.join(" ")}"

    bin.install "ldid"
    bin.install_symlink "ldid" => "ldid2"
  end

  test do
    cp test_fixtures("mach/a.out"), testpath
    system bin/"ldid", "-S", "a.out"
  end
end
