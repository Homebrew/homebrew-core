class Libsidplayfp < Formula
  desc "Library to play Commodore 64 music"
  homepage "https://github.com/libsidplayfp/libsidplayfp"
  url "https://github.com/libsidplayfp/libsidplayfp/releases/download/v3.0.2/libsidplayfp-3.0.2.tar.gz"
  sha256 "d67ab120ab8ca10657c0e33a7fc21638484e1af4037738c36faa66fb7747cac3"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "50320df69e63567386233c1a6608af633f1ef2b56021e8177f3ad84381ab3235"
    sha256 cellar: :any, arm64_sequoia: "a948282b22f4510ef90fb1c15477f63551f8940ab6dd6865220de3c2f3621f51"
    sha256 cellar: :any, arm64_sonoma:  "f27a944d2b606a32c908bc4111d3c12c87c23c1cceed9db871c920fb8eaa0ecb"
    sha256 cellar: :any, sonoma:        "3ad5e80d324dca8717301738e4677571523c04026ce2584df14b3dad9bb3cf6f"
    sha256 cellar: :any, arm64_linux:   "307f50f0e1bd633cb70daa636d8a495acef108e27b83cbee4a4941755ebb3561"
    sha256 cellar: :any, x86_64_linux:  "e8ddecf787083137430f7726f9c1492543b0520c93c73489a623c7a549926a94"
  end

  head do
    url "https://github.com/libsidplayfp/libsidplayfp.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "coreutils" => :build
    depends_on "libtool" => :build
    depends_on "xa" => :build
  end

  depends_on "pkgconf" => :build

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <sidplayfp/sidplayfp.h>

      int main() {
          sidplayfp play;
          std::cout << LIBSIDPLAYFP_VERSION_MAJ << "."
                    << LIBSIDPLAYFP_VERSION_MIN << "."
                    << LIBSIDPLAYFP_VERSION_LEV;
          return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-L#{lib}", "-I#{include}", "-lsidplayfp", "-o", "test"
    assert_equal version.to_s, shell_output("./test")
  end
end
