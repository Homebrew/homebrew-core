class Libre < Formula
  desc "Toolkit library for asynchronous network I/O with protocol stacks"
  homepage "https://github.com/baresip/re"
  url "https://github.com/baresip/re/archive/refs/tags/v4.7.0.tar.gz"
  sha256 "b9fd286e30df103b3e06be2f821503d6f21551002737c4b8f47cf8db30dd5e19"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "70969e170240318aca3e08d2fd6f8c3dc0f9ce96bb1fff89d45599ce1b502d27"
    sha256 cellar: :any,                 arm64_sequoia: "dd9b777a67722bcc8f15d101f92ff6b0ca1aab87f3a96801de3fd384d0e46d50"
    sha256 cellar: :any,                 arm64_sonoma:  "4327496129de4fca151e8b00342996f2548ff0f3f92ce3c8b0cb40166d52551c"
    sha256 cellar: :any,                 sonoma:        "557c21463b26a8d145147b6cff2b7ff5d64d80a08898a2cd0b44dc0e7fc0c42b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7010dc9c9706091b8fd6b270b42448a6cd7f93da85e402d7d6c92dd1ee1b4560"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f1fdf6715008f5507be923ba5cb410e06f223bc0f2b667810f2284bcc6af2fa"
  end

  depends_on "cmake" => :build
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # OpenSSL 4+ support:
  # PR ref: https://github.com/baresip/re/pull/1570, https://github.com/baresip/re/pull/1572
  patch do
    url "https://github.com/baresip/re/commit/3fe6bd197545e800cd3e027c04d50e8ef27e6aa1.patch?full_index=1"
    sha256 "10c98b0ca73055eeccf0e70cb7eaf1d153025acaa6774444570d15eb83a45118"
  end
  patch do
    url "https://github.com/baresip/re/commit/6d9dc45866766df9f74f7371e81baa00fbc7efb5.patch?full_index=1"
    sha256 "f259c04500bfa7afc01f23b358abe2fe9cac1ebbe6e508ad8371ffcbeaccf8c9"
  end

  def install
    system "cmake", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdint.h>
      #include <re/re.h>
      int main() {
        return libre_init();
      }
    C
    system ENV.cc, "-I#{include}", "-I#{include}/re", "test.c", "-L#{lib}", "-lre"
  end
end
