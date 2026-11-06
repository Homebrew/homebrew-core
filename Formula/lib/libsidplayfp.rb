class Libsidplayfp < Formula
  desc "Library to play Commodore 64 music"
  homepage "https://github.com/libsidplayfp/libsidplayfp"
  url "https://github.com/libsidplayfp/libsidplayfp/releases/download/v3.1.2/libsidplayfp-3.1.2.tar.gz"
  sha256 "6d16c20e523ac4d3e385531dafe247a830b59bcb4eb73a557f15cf4e7ae6da84"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "32e02d3142a0d86bae26899a23d4549e2c7abde2b303cad7e750c108d98aa464"
    sha256 cellar: :any, arm64_tahoe:       "67e359a1976948d5cb47aca7b3f9be9639967f8866953baa1b4d6ad9a1132687"
    sha256 cellar: :any, arm64_sequoia:     "6020a145aac9cfca4e20ddb830f587012d59b685196d546aacbbbf9a1f9b9cc2"
    sha256 cellar: :any, arm64_linux:       "e9a9bb0d49e56fa3b85e18d31b43d27b4806196e28f299f1e21f488d42bfcc22"
    sha256 cellar: :any, x86_64_linux:      "8dd548283b2488d819fe6301ab94ef66d0620f8be70f3dc2a4bb5604b4ab02fe"
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

  deny_network_access!

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
