class Libcoap < Formula
  desc "Lightweight application-protocol for resource-constrained devices"
  homepage "https://github.com/obgm/libcoap"
  url "https://github.com/obgm/libcoap/archive/refs/tags/v4.3.5.tar.gz"
  sha256 "a417ed26ec6c95c041b42353b5b6fad1602e2bf42a6e26c09863450e227b7b5f"
  license "BSD-2-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "a98670de3fe4ec6aa76bce6909dcb2e4508d965d16f8d5087e08d11561dc3f8a"
    sha256 cellar: :any,                 arm64_sonoma:  "3e1ccc1ecda3c10ba83e6c427e83cf30166cc8693821914426ef5b35e024d12f"
    sha256 cellar: :any,                 arm64_ventura: "3509f77235a4648fb6242af0573ab2d864f5347b78e941b70d3695f4c8c1970c"
    sha256 cellar: :any,                 sonoma:        "7c1e314e9154f828266e6e6077564e0f87450ee55047f7d1f96d99a8c4b7047b"
    sha256 cellar: :any,                 ventura:       "cd74e8814cc3d2fe124bc986455a778412efde46f3a4487038c8b634e291882f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c7fcac4998b5144353646f90861e0261a84882480e2bc98f0805e4fc676bfce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ede5117a7134ea1750a9ae100837280ff4b971c00e995196b2f669dde62320d"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-manpages", "--disable-doxygen", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    port = free_port
    spawn bin/"coap-server", "-p", port.to_s
    sleep 1
    output = shell_output(bin/"coap-client -B 5 -m get coap://localhost:#{port}")
    assert_match "This is a test server made with libcoap", output
  end
end
