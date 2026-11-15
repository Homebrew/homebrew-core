class Dnswire < Formula
  desc "Library for encoding/decoding different DNS encapsulations"
  homepage "https://codeberg.org/DNS-OARC/dnswire"
  url "https://www.dns-oarc.net/files/dnswire/dnswire-0.5.1.tar.gz"
  sha256 "b0b52b95e20eda768256794097080b5f5725d9fe841ef03568c51987b02673b4"
  license "GPL-3.0-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "af08e098cecfb092e02ee3691645f92ec7722c36d212cce26247694e26b2a118"
    sha256 cellar: :any, arm64_tahoe:       "df58fe562d38ba6f322fc544785067297c906e36d16e1fd4f6c88247ed2325e2"
    sha256 cellar: :any, arm64_sequoia:     "88561139efd02ecb260684607567214d0520c0149addfd311f3a14038981ca74"
    sha256 cellar: :any, arm64_linux:       "d0d6700556292ab1529f023bd79b4e9ba51afb347f081f817532d071580b102a"
    sha256 cellar: :any, x86_64_linux:      "f1a3ca678aa56cc9a823a59c381822fb718ad4a3212d161ab256cb7adb3192e9"
  end

  depends_on "pkgconf" => [:build, :test]
  depends_on "libuv"
  depends_on "protobuf-c"
  depends_on "tinyframe"

  deny_network_access!

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <dnswire/version.h>
      #include <stdio.h>

      int main(int argc, char *argv[]) {
        printf("Version %s", DNSWIRE_VERSION_STRING);
        return 0;
      }
    C
    flags = shell_output("pkgconf --cflags --libs libdnswire").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    assert_match version.to_s, shell_output("./test")
  end
end
