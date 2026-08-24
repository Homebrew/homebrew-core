class Libsidplayfp < Formula
  desc "Library to play Commodore 64 music"
  homepage "https://github.com/libsidplayfp/libsidplayfp"
  url "https://github.com/libsidplayfp/libsidplayfp/releases/download/v3.1.0/libsidplayfp-3.1.0.tar.gz"
  sha256 "12a7ba238a6f61a811134a31d494e251eba0dd8f1c03b627d2422d8133a3584b"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "055a7aa1496c9db634b2edc40f1350ccfccec0686154a77dc4aea48fa5da1d69"
    sha256 cellar: :any, arm64_sequoia: "1684328b1f6a4e0d79156db33f802cb71ebb8c0d4f0182cd37d8f761a68c7c05"
    sha256 cellar: :any, arm64_sonoma:  "a2278e679f0c3069b59235582c285488b54be2281a319f8310dfcdb9bc773538"
    sha256 cellar: :any, sonoma:        "c80f00a276dbe802327ea031d963d4ef72d322e5761b77ba2e3cd6acbc94460a"
    sha256 cellar: :any, arm64_linux:   "05fcc8d7f1aa4fdda796505d5604107cb7e5e3a450245b100496bb2bc8d928eb"
    sha256 cellar: :any, x86_64_linux:  "74633a6bf403aa0851505db0576ae13e390c5296f6a1b1766731f2ac4c919fd8"
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
