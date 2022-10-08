class Libre < Formula
  desc "Toolkit library for asynchronous network I/O with protocol stacks"
  homepage "https://github.com/baresip/re"
  url "https://github.com/baresip/re/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "6aa9622bc0fee6881770e0b374161df44edb395b5d295fc8c56e7b6fa18a8ea2"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8442c6a7a3bc3ab9bf559cd04b2781c31f36497504af9d27b9794c364cf1822f"
    sha256 cellar: :any,                 arm64_big_sur:  "17a3557298806e77aed51910f2ec284459e9c9ee58769455c954606359fe2e49"
    sha256 cellar: :any,                 monterey:       "cc9f01e6dd4aeed65a2a4fce43879c15835c189d53ef2b2f960e7f49ce3eed00"
    sha256 cellar: :any,                 big_sur:        "e1c9883a3409eace6b417ecf60738bfed7f43afcc300c4477c6019f29e4fea04"
    sha256 cellar: :any,                 catalina:       "4e078dfc396824f0ac8c0bbf22790fc76b15a66328a0aeaec646a723342ea71d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1dc246a8e27447e328d2aecb6450c16f82431caed7381b2371c4264720207bf3"
  end

  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    sysroot = "SYSROOT=#{MacOS.sdk_path}/usr" if OS.mac?
    system "make", *sysroot, "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdint.h>
      #include <re/re.h>
      int main() {
        return libre_init();
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lre"
  end
end
