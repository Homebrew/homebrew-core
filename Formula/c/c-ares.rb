class CAres < Formula
  desc "Asynchronous DNS library"
  homepage "https://c-ares.org/"
  url "https://c-ares.org/download/c-ares-1.28.1.tar.gz"
  mirror "https://github.com/c-ares/c-ares/releases/download/cares-1_17_2/c-ares-1.28.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/dns/c-ares-1.28.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/dns/legacy/c-ares-1.28.1.tar.gz"
  sha256 "675a69fc54ddbf42e6830bc671eeb6cd89eeca43828eb413243fd2c0a760809d"
  license "MIT"
  head "https://github.com/c-ares/c-ares.git", branch: "main"

  livecheck do
    url :homepage
    regex(/href=.*?c-ares[._-](\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2a9f7c8f62d45593810a0fc926f6eec6e71a027774424240485c7d89bce15270"
    sha256 cellar: :any,                 arm64_ventura:  "b8d774a6004c8c25a5841967033468e742e4183a5e8e949339af6a767ae6da8b"
    sha256 cellar: :any,                 arm64_monterey: "7c2c0ef8b218f3f399d05e0e1767484ff66227051b11de2665b9df4e55c85103"
    sha256 cellar: :any,                 sonoma:         "acf887fff7983e2e9d5eae0c9e1d9e3a8876732f448fe1853c848695ad3e79a2"
    sha256 cellar: :any,                 ventura:        "78ad4963b8c6fe375b855c852b84b94c543131d5b676a1d8cf18d246a54f69a7"
    sha256 cellar: :any,                 monterey:       "a24809a5b29f4007977787ff9f5afcac869bdff46a28163537beef72fa4de645"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8f453981c410c937dae06314ad4e88a442a212ef1a3e0b8090a07755788299d"
  end

  depends_on "cmake" => :build

  def install
    args = %W[
      -DCARES_STATIC=ON
      -DCARES_SHARED=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <ares.h>

      int main()
      {
        ares_library_init(ARES_LIB_INIT_ALL);
        ares_library_cleanup();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lcares", "-o", "test"
    system "./test"

    system "#{bin}/ahost", "127.0.0.1"
  end
end
