class Opendht < Formula
  desc "C++17 Distributed Hash Table implementation"
  homepage "https://github.com/savoirfairelinux/opendht"
  url "https://github.com/savoirfairelinux/opendht/archive/refs/tags/v3.6.0.tar.gz"
  sha256 "b02de211123191a53ad680226bc2f33145ee24f276a37cd7bbc64d0b7d2d4651"
  license "GPL-3.0-or-later"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "22cd8912a51484ce9923c18769b5c44b20c29f783a9f40055aba2262a2b19669"
    sha256 cellar: :any,                 arm64_sequoia: "0281e1768df938d3b88e00617196eb9dcd10d63da475f338574673fd5575885c"
    sha256 cellar: :any,                 arm64_sonoma:  "a496f6a54f21405c3d3775bc1508cd990226f736e4e47a4cb22a7eb0d9fd6bc4"
    sha256 cellar: :any,                 sonoma:        "f521ae539b881d60096ba21b53eb23d9f84d09f1e34f306253cc06c8a8c27d89"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd19b1d153f02943ff203cff27dfc83e195c05de6abc28966b1399c968772d5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0e36fec6dc58426cd26b211204c0d7e3355decdb3d3d2abbb8e14953a75af18"
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
