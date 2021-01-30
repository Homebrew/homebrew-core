class Neovim < Formula
  desc "Ambitious Vim-fork focused on extensibility and agility"
  homepage "https://neovim.io/"
  url "https://github.com/neovim/neovim/archive/v0.4.4.tar.gz"
  sha256 "2f76aac59363677f37592e853ab2c06151cca8830d4b3fe4675b4a52d41fc42c"
  license "Apache-2.0"
  revision 1

  bottle do
    rebuild 1
    sha256 big_sur:     "83957460b7c664b65f7339c6e37a6b468274ca747ba8f8746616c4cebf97caa9"
    sha256 catalina:    "736260e14d50d9a42562fb0fe2215d5154a9cef3e3227469a961d030b45358fd"
    sha256 mojave:      "9f8a7cb52a0060c524d4d4f96b2590d034257cc4f255a8f05dfbf464bef29cf1"
    sha256 high_sierra: "7286d497b92cf31f5839af325a1fc7760fb3006fa4a0dad7e547ab9c966cb491"
  end

  head do
    url "https://github.com/neovim/neovim.git"
    depends_on "tree-sitter"
  end

  depends_on "cmake" => :build
  depends_on "luarocks" => :build
  depends_on "luv" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "libtermkey"
  depends_on "libuv"
  depends_on "libvterm"
  depends_on "luajit-openresty"
  depends_on "msgpack"
  depends_on "unibilium"

  uses_from_macos "gperf" => :build
  uses_from_macos "unzip" => :build

  on_linux do
    depends_on "libnsl"
  end

  # Keep resources updated according to:
  # https://github.com/neovim/neovim/blob/v#{version}/third-party/CMakeLists.txt

  resource "mpack" do
    url "https://github.com/libmpack/libmpack-lua/releases/download/1.0.8/libmpack-lua-1.0.8.tar.gz"
    sha256 "ed6b1b4bbdb56f26241397c1e168a6b1672f284989303b150f7ea8d39d1bc9e9"
  end

  resource "lpeg" do
    url "https://luarocks.org/manifests/gvvaughan/lpeg-1.0.2-1.src.rock"
    sha256 "e0d0d687897f06588558168eeb1902ac41a11edd1b58f1aa61b99d0ea0abbfbc"
  end

  resource "inspect" do
    url "https://luarocks.org/manifests/kikito/inspect-3.1.1-0.src.rock"
    sha256 "ea1f347663cebb523e88622b1d6fe38126c79436da4dbf442674208aa14a8f4c"
  end

  # Patch for Apple Silicon. Backported from
  # https://github.com/neovim/neovim/pull/12624
  patch :DATA

  def install
    resources.each do |r|
      r.stage(buildpath/"deps-build/build/src/#{r.name}")
    end

    ENV.prepend_path "LUA_PATH", "#{buildpath}/deps-build/share/lua/5.1/?.lua"
    ENV.prepend_path "LUA_CPATH", "#{buildpath}/deps-build/lib/lua/5.1/?.so"
    lua_path = "--lua-dir=#{Formula["luajit-openresty"].opt_prefix}"

    cmake_compiler_args = []
    on_macos do
      cmake_compiler_args << "-DCMAKE_C_COMPILER=/usr/bin/clang"
      cmake_compiler_args << "-DCMAKE_CXX_COMPILER=/usr/bin/clang++"
    end

    cd "deps-build" do
      %w[
        mpack/mpack-1.0.8-0.rockspec
        lpeg/lpeg-1.0.2-1.src.rock
        inspect/inspect-3.1.1-0.src.rock
      ].each do |rock|
        dir, rock = rock.split("/")
        cd "build/src/#{dir}" do
          output = Utils.safe_popen_read("luarocks", "unpack", lua_path, rock, "--tree=#{buildpath}/deps-build")
          unpack_dir = output.split("\n")[-2]
          cd unpack_dir do
            system "luarocks", "make", lua_path, "--tree=#{buildpath}/deps-build"
          end
        end
      end
    end

    mkdir "build" do
      cmake_args = std_cmake_args
      cmake_args += cmake_compiler_args
      cmake_args += %W[
        -DLIBLUV_INCLUDE_DIR=#{Formula["luv"].opt_include}
        -DLIBLUV_LIBRARY=#{Formula["luv"].opt_lib}/libluv_a.a
      ]
      system "cmake", "..", *cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.txt").write("Hello World from Vim!!")
    system bin/"nvim", "--headless", "-i", "NONE", "-u", "NONE",
                       "+s/Vim/Neovim/g", "+wq", "test.txt"
    assert_equal "Hello World from Neovim!!", (testpath/"test.txt").read.chomp
  end
end

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 6b3a8dc..f3370e3 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -358,16 +358,6 @@ if(CMAKE_C_COMPILER_ID STREQUAL "GNU" OR CMAKE_C_COMPILER_ID STREQUAL "Clang")
   add_definitions(-D_GNU_SOURCE)
 endif()
 
-if(CMAKE_SYSTEM_NAME STREQUAL "Darwin" AND CMAKE_SIZEOF_VOID_P EQUAL 8)
-  # Required for luajit.
-  set(CMAKE_EXE_LINKER_FLAGS
-    "${CMAKE_EXE_LINKER_FLAGS} -pagezero_size 10000 -image_base 100000000")
-  set(CMAKE_SHARED_LINKER_FLAGS
-    "${CMAKE_SHARED_LINKER_FLAGS} -image_base 100000000")
-  set(CMAKE_MODULE_LINKER_FLAGS
-    "${CMAKE_MODULE_LINKER_FLAGS} -image_base 100000000")
-endif()
-
 include_directories("${PROJECT_BINARY_DIR}/config")
 include_directories("${PROJECT_SOURCE_DIR}/src")
 
