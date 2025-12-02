class Libconfig < Formula
  desc "Configuration file processing library"
  homepage "https://hyperrealm.github.io/libconfig/"
  url "https://github.com/hyperrealm/libconfig/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "e95798d2992a66ecd547ce3651d7e10642ff2211427c43a7238186ff4c372627"
  license "LGPL-2.1-or-later"
  head "https://github.com/hyperrealm/libconfig.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2748d8bececbd0c049b704a83376b556314cec841d107f5a0d2da4b72caaf034"
    sha256 cellar: :any,                 arm64_sequoia: "a7f4c911aed6b617d9b54898d2db28752beb4ae8c6fedc542e078d7153393b8d"
    sha256 cellar: :any,                 arm64_sonoma:  "cf947b246c6fa471c84bdabc72cd0b9cc308cf8c5c73ecf3c31a584e86e07c56"
    sha256 cellar: :any,                 arm64_ventura: "f676b9722a4ea9abdb769d59b7d77efcebd06b16ca2a25178da5dc06b7732a7c"
    sha256 cellar: :any,                 sonoma:        "680393735071e707fa197403ae718784169ca78f9114b75cf2642bc1d284e3b4"
    sha256 cellar: :any,                 ventura:       "845d83dcd540e6b4f2e7a50aa63e4435a32cc4cf680776dd67a79f0f70f9b585"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "550be19328331c113b05238452db7e0fdf42a2a317a4c59c829fe60587a98bb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83ee143485d7fdf1c9f4d72a95811c8e200665de550972786ff89129fe035542"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  uses_from_macos "flex" => :build

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libconfig.h>
      int main() {
        config_t cfg;
        config_init(&cfg);
        config_destroy(&cfg);
        return 0;
      }
    C
    system ENV.cc, testpath/"test.c", "-I#{include}",
           "-L#{lib}", "-lconfig", "-o", testpath/"test"
    system "./test"
  end
end
