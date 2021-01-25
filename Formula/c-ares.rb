class CAres < Formula
  desc "Asynchronous DNS library"
  homepage "https://c-ares.haxx.se/"
  url "https://c-ares.haxx.se/download/c-ares-1.17.1.tar.gz"
  sha256 "d73dd0f6de824afd407ce10750ea081af47eba52b8a6cb307d220131ad93fc40"
  license "MIT"
  head "https://github.com/c-ares/c-ares.git"

  livecheck do
    url :homepage
    regex(/href=.*?c-ares[._-](\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "514de64e48f4d2c6e448547a30ba03f613b899f30f97f9026740c59eb3f49aeb" => :big_sur
    sha256 "63627c4d2e4698ba13b82aeb2a10f3aef3a7bcbb7b459c265dbd840e91e5b175" => :arm64_big_sur
    sha256 "3fc1e6a9c560039998b288db7dfb268c87db614841a6fa1048880b8b6bdd6e4c" => :catalina
    sha256 "8785faa759b2f10fcaefef1e7398b9ffe79b76b2339b4bc4b552fd9c418b1097" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-GNinja", *std_cmake_args
      system "ninja"
      system "ninja", "install"
    end
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
  end
end
