class Opendht < Formula
  desc "C++17 Distributed Hash Table implementation"
  homepage "https://github.com/savoirfairelinux/opendht"
  url "https://github.com/savoirfairelinux/opendht/archive/refs/tags/v3.5.4.tar.gz"
  sha256 "674249c4ac07c4392566d761c0189c7bb11dd7b17e9a331c69d6881f7d01e043"
  license "GPL-3.0-or-later"
  revision 1

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f4d45049caf08fd1f826f1869952f62954692a6c68f212e5a969ff3f863a74a1"
    sha256 cellar: :any,                 arm64_sequoia: "df77e683bd89ca2fa48b3999397edbde77ef84cae513656341117d3d3101e243"
    sha256 cellar: :any,                 arm64_sonoma:  "43363010a5daf03f140e0b157ac35f940ac19b52ed2e258a6b03ae7140afd8b5"
    sha256 cellar: :any,                 sonoma:        "62be175424effde9bda516c6f027d71c6ab220232ad1007dc8a1d7cbcb650285"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e746a7d89e61ce715a0e5bb243838c9ec8ac142829df34922919c9f3cdf5a67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d7aac90140280403abba3a269270f4c1f0fd63760ee9404fd173831e5824026"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "argon2"
  depends_on "asio"
  depends_on "fmt"
  depends_on "gnutls"
  depends_on "msgpack-cxx"
  depends_on "nettle"
  depends_on "readline"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DOPENDHT_C=ON",
                    "-DOPENDHT_TOOLS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <opendht.h>
      int main() {
        dht::DhtRunner node;

        // Launch a dht node on a new thread, using a
        // generated RSA key pair, and listen on port 4222.
        node.run(4222, dht::crypto::generateIdentity(), true);
        node.join();

        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++17", "-L#{lib}", "-lopendht", "-o", "test"
    system "./test"
  end
end
