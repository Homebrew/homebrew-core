class Libsidplayfp < Formula
  desc "Library to play Commodore 64 music"
  homepage "https://github.com/libsidplayfp/libsidplayfp"
  url "https://github.com/libsidplayfp/libsidplayfp/releases/download/v2.15.2/libsidplayfp-2.15.2.tar.gz"
  sha256 "7c6ab283fda53d34973fa266fc3809e16964dd8ccb7edcc11516ef5e3f66b3cd"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "65e0d8914bf8d0c5e42f05ae401d25f65b5b116b2af79b04d17aa231c61be0a4"
    sha256 cellar: :any,                 arm64_sequoia: "e8e9c176b128de56de5da423f4cd88ba61192aa9faf541191c3d7dbb8e1220c1"
    sha256 cellar: :any,                 arm64_sonoma:  "b0960122ff1c866c737600c2579e8513149616b82b2feb2c2eb0fe80b757429a"
    sha256 cellar: :any,                 sonoma:        "b9fe1ef83b3e5ef08dc02f8765df57aeea5a85cfd809fd76d9f2492899ef6cb4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "adfe9041ae013a9170e57a60d89be16970ee5015e9bb8a6818a8f24b7bcf6e52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69015567aad0ff9e497502895b5c26d0a85887c4ff3d5e162d53851e9b04501b"
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
  depends_on "libgcrypt"

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
