class Libsidplayfp < Formula
  desc "Library to play Commodore 64 music"
  homepage "https://github.com/libsidplayfp/libsidplayfp"
  url "https://github.com/libsidplayfp/libsidplayfp/releases/download/v3.1.1/libsidplayfp-3.1.1.tar.gz"
  sha256 "12b79190593bf480b2d11481b5c2de62bac07f344437a66cd8d887329875c626"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "79d38e35f7b5052c5a00bbd9e746cfddafe19610f3540227b8edc49a670d5cf7"
    sha256 cellar: :any, arm64_tahoe:       "7e28827526f55a6b86db4ab3f6ec73d8444f0d0c70c1b2c1144928b19d8ce0dc"
    sha256 cellar: :any, arm64_sequoia:     "39d7143aceb9cde1239627dc1df9bd12e28573f8d8c9f13fc110b4b74ebd5ec0"
    sha256 cellar: :any, arm64_sonoma:      "e96a6cc0b430e12ba54dbe05ae9724699cff7f06506d8381ceaa12f19ed7f4f6"
    sha256 cellar: :any, arm64_linux:       "e74e18a0eb0568246bb616aac2110af63e1f50138e52e234c9bb703c4fe03cc9"
    sha256 cellar: :any, x86_64_linux:      "4d69b454dad108db93d41bb4ae086a3c22b187da4d495b0ba83ed2c5c4605161"
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
