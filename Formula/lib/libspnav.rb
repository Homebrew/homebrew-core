class Libspnav < Formula
  desc "Client library for connecting to 3Dconnexion's 3D input devices"
  homepage "https://spacenav.sourceforge.net/"
  url "https://github.com/FreeSpacenav/libspnav/releases/download/v1.2/libspnav-1.2.tar.gz"
  sha256 "093747e7e03b232e08ff77f1ad7f48552c06ac5236316a5012db4269951c39db"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8617c396bcd6038db8011ef5b64b829c539d70cd80e535e98ae3c556f4ce8b2c"
    sha256 cellar: :any,                 arm64_sequoia: "a7843164737d207e0440e5284516dc5c77f52283a2a93151460d7a0c6ad7a271"
    sha256 cellar: :any,                 arm64_sonoma:  "c558c47488603645fff95ff479a3b52c28d1f96d5d774142c65f58735dac31e2"
    sha256 cellar: :any,                 arm64_ventura: "86fcbcb81651468778b50817d02e5eb4b870ae5974b9c997675c238293549734"
    sha256 cellar: :any,                 sonoma:        "2930ff1e49f96695150603db974beaa4b731d8593e25c30378d3b10dc484a94f"
    sha256 cellar: :any,                 ventura:       "6e94c48a7c3a4a183efec643f50147e9172d25d78278557a830ad08df5f99071"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0fff8d5004804ef7849dd0541b461af209fcd8a96645cc0461e74847a34788c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e770b50e19f7cdd6992eaea4a8595e6690074854396f371169787f5609a47d75"
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --disable-x11
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <spnav.h>

      int main() {
        bool connected = spnav_open() != -1;
        if (connected) spnav_close();
        return 0;
      }
    CPP
    system ENV.cc, "test.cpp", "-I#{include}", "-L#{lib}", "-lspnav", "-lm", "-o", "test"
    system "./test"
  end
end
