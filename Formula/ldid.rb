class Ldid < Formula
  desc "Lets you manipulate the signature block in a Mach-O binary"
  homepage "https://cydia.saurik.com/info/ldid/"
  url "https://git.saurik.com/ldid.git",
      tag:      "v2.1.5",
      revision: "a23f0faadd29ec00a6b7fb2498c3d15af15a7100"
  license "AGPL-3.0-or-later"
  head "https://git.saurik.com/ldid.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0ac9a13e531213216609846e8119f52647b3a5a40f2e24a29cd4a1c670326c76"
    sha256 cellar: :any,                 arm64_big_sur:  "24ad6542039d4d6be36a6d4ecd3f0c693e1f184608e68edbb47c9e9184af8b36"
    sha256 cellar: :any,                 monterey:       "7cd2258538aab23539e42b7b6eddbd213c8a2d1e6a6ef5b1516d444657800b9e"
    sha256 cellar: :any,                 big_sur:        "cc64fe39c44a0f1f8bd317526f7e9addb7462738fde043c428f2132119da8fdd"
    sha256 cellar: :any,                 catalina:       "076869a16234577407b0ea659e117863b927f9c3ac3c5b7cbde9d73af0b998ac"
    sha256 cellar: :any,                 mojave:         "986774410fa97d8f9afc40d378ee97c9ea6e3b18d8055f3881c12a68466e38b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "670cf109fed75163204dc01f6c52ce2b9809615c765a2001662cc3e3a192053c"
  end

  depends_on "libplist"
  depends_on "openssl@1.1"
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
