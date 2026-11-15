class Libconfig < Formula
  desc "Configuration file processing library"
  homepage "https://hyperrealm.github.io/libconfig/"
  url "https://github.com/hyperrealm/libconfig/archive/refs/tags/v1.8.3.tar.gz"
  sha256 "683f723d647befcdb36e1a4a61a83ae8c89dc7959ca872a7407b6c8152104162"
  license "LGPL-2.1-or-later"
  compatibility_version 1
  head "https://github.com/hyperrealm/libconfig.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "3cecf81e99f63923dc8f475656aef0922387d8e0d465e7d79d07cfbeb520bba9"
    sha256 cellar: :any, arm64_tahoe:       "e328b92ea0251f0c31d2215ff60126398f6f5329fafef8a3d2b08d7e6c4fceff"
    sha256 cellar: :any, arm64_sequoia:     "89954857881c002763056e8d2c461bcc489f9528ee963bd04f9c5e08f7c00fb3"
    sha256 cellar: :any, arm64_linux:       "7d4921783cbf9d32de337453d3916f5c967a2041e817d580d0314aea2c35ed90"
    sha256 cellar: :any, x86_64_linux:      "c627568cc9f75ef47039f0c04f9595367e9051471c15a94d5b77c1ae35571176"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  uses_from_macos "flex" => :build

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  deny_network_access!

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
