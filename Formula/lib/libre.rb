class Libre < Formula
  desc "Toolkit library for asynchronous network I/O with protocol stacks"
  homepage "https://github.com/baresip/re"
  url "https://github.com/baresip/re/archive/refs/tags/v3.5.1.tar.gz"
  sha256 "5cf31f95cd3d7df14c8f27a38b94a328b4d67c300686b49b6fae9cc0552f86e8"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0485d0bb5ab296c62cbbf1afaeb10ea123ccb5dffadd88c6d2217b3387f863bb"
    sha256 cellar: :any,                 arm64_ventura:  "1342ebd62049107fa5c78740d0ddde34637e9280dd47ca21056fe49911a106d7"
    sha256 cellar: :any,                 arm64_monterey: "458540a7e59627348817c9eef0460a1bcb50a8cfc6399f1df81b3cb963e08eee"
    sha256 cellar: :any,                 arm64_big_sur:  "d4818ab3c1caab097289484e72e9ae1cc39a597aa82ab889e080b5180cc25536"
    sha256 cellar: :any,                 sonoma:         "53aa88b657d9845aaabc59228c387a961e2b9d8115287a37dc0966a12f96280b"
    sha256 cellar: :any,                 ventura:        "8f666b83be92cac42a5a6d578c4ce812849d698aaf16a178ff98ae9970b2e83d"
    sha256 cellar: :any,                 monterey:       "42bba09cfcb6920dea7ec71b37f5b490480d39cb937b5d60926670d59ecc3049"
    sha256 cellar: :any,                 big_sur:        "5a0b7e0a6c10ef37c0bbf3087052943ac623f7d76a39df1a44fb0d719ada6432"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2f29d5f352c2d0c456b417cb2f716ad0144ec09532965d6270deceab58f77dc"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cmake", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdint.h>
      #include <re/re.h>
      int main() {
        return libre_init();
      }
    EOS
    system ENV.cc, "-I#{include}", "-I#{include}/re", "test.c", "-L#{lib}", "-lre"
  end
end
