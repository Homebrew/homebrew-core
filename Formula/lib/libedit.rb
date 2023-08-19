class Libedit < Formula
  desc "BSD-style licensed readline alternative"
  homepage "https://thrysoee.dk/editline/"
  url "https://thrysoee.dk/editline/libedit-20221030-3.1.tar.gz"
  version "20221030-3.1"
  sha256 "f0925a5adf4b1bf116ee19766b7daa766917aec198747943b1c4edf67a4be2bb"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?libedit[._-]v?(\d{4,}-\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b7b13324abc4ddd0eac78fb9cb202ef9eccb4044ae719203cd933754c3588a85"
    sha256 cellar: :any,                 arm64_monterey: "31b5d595de266712ea96a3246683f4781116f58578820241c3810d1605a4e55c"
    sha256 cellar: :any,                 arm64_big_sur:  "a3a10d198a10b033e2ea3d4cc08b7a61118587618b38861b55365226e955aa0e"
    sha256 cellar: :any,                 ventura:        "0eba9829c27aae6bd7b331d27200c34efba436d8cb6643ca549d4b0067db6723"
    sha256 cellar: :any,                 monterey:       "4f0f05f70b2d444915583eb0d54006663e42a38c5be0a9f9c9ce6510a0934bed"
    sha256 cellar: :any,                 big_sur:        "ce66e3881e8ef465281639cd032707ef9bed833309b2879db34e1a6318fda580"
    sha256 cellar: :any,                 catalina:       "13d64d1c3f21a1e0299a53f2d636d5cd60d5d62df53e6dcb2ee3c8cade3b53b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bee1f6bfb90dd3c9b26ce4732e04025a468fe2fa29d63049cb0aa2a888e610d2"
  end

  keg_only :provided_by_macos

  uses_from_macos "ncurses"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"

    if OS.linux?
      # Conflicts with readline.
      mv man3/"history.3", man3/"history_libedit.3"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <histedit.h>
      int main(int argc, char *argv[]) {
        EditLine *el = el_init(argv[0], stdin, stdout, stderr);
        return (el == NULL);
      }
    EOS
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-ledit", "-I#{include}"
    system "./test"
  end
end
