class Luabind < Formula
  desc "Library for bindings between C++ and Lua"
  homepage "https://github.com/luabind/luabind"
  url "https://downloads.sourceforge.net/project/luabind/luabind/0.9.1/luabind-0.9.1.tar.gz"
  sha256 "80de5e04918678dd8e6dac3b22a34b3247f74bf744c719bae21faaa49649aaae"
  license "MIT"
  revision 2

  bottle do
    sha256 cellar: :any, arm64_monterey: "2aa06fda6b16e944418e0bbb8306794b6a37574cc3498b979e50d3bf63126045"
    sha256 cellar: :any, arm64_big_sur:  "412b4800d6e640819f77c80cdf5b6597cb5357caebd499e9b32577d27ddeab5c"
    sha256 cellar: :any, monterey:       "676b9de9bb164333be0f98da20ce853cfdf54234f3a9536303308e6e8598c589"
    sha256 cellar: :any, big_sur:        "adf679efd6e24a319ef2481cf51e75f2098ab9d9284c0acc48c88363cc15eba2"
    sha256 cellar: :any, catalina:       "cc7fc93a6ae050ea6fb11c1c961c7e8cfea5ca3f78407c069f2210c598a38823"
    sha256 cellar: :any, mojave:         "aa095d38915e09287c86d11d65871b5a4e6604799a961f0e055c9bf526ba403b"
    sha256 cellar: :any, high_sierra:    "736bb4cb6a49338eecab9a179f3104e8328d7133366b921b2fece14b6fd2aa26"
    sha256 cellar: :any, sierra:         "39e74593d47fd648230e177e9a8a90e1b3a888c84d6c7d38f358265d5b93ce94"
    sha256 cellar: :any, el_capitan:     "914a79679264790d9ffb0726a1f303954d816da3dd23db3b8816873cf467677f"
    sha256 cellar: :any, yosemite:       "171123f48a6cf2431d6b143b84bf31dbb955f103195aa30597a61b7a61943982"
  end

  depends_on "boost-build" => :build
  depends_on "boost"
  depends_on "lua@5.1"

  # boost 1.57 compatibility
  # https://github.com/Homebrew/homebrew/pull/33890#issuecomment-67723688
  # https://github.com/luabind/luabind/issues/27
  patch do
    url "https://gist.githubusercontent.com/tdsmith/e6d9d3559ec1d9284c0b/raw/4ac01936561ef9d7541cf8e78a230bebef1a8e10/luabind.diff"
    sha256 "f22a283752994e821922316a5ef3cbb16f7bbe15fc64d97c02325ed4aaa53985"
  end

  # patch Jamroot to perform lookup for shared objects with .dylib suffix
  patch do
    url "https://gist.githubusercontent.com/DennisOSRM/3728987/raw/052251fcdc23602770f6c543be9b3e12f0cac50a/Jamroot.diff"
    sha256 "bc06d76069d08af4dc55a102f963931a0247173a36ad0ae43e11d82b23f8d2b3"
  end

  # apply upstream commit to enable building with clang
  patch do
    url "https://github.com/luabind/luabind/commit/3044a9053ac50977684a75c4af42b2bddb853fad.patch?full_index=1"
    sha256 "0e213656165de17c2047e18ac451fa891355a7f58b2995b5b8e0d95c23acdb1c"
  end

  # include C header that is not pulled in automatically on OS X 10.9 anymore
  # submitted https://github.com/luabind/luabind/pull/20
  patch do
    url "https://gist.githubusercontent.com/DennisOSRM/a246514bf7d01631dda8/raw/0e83503dbf862ebfb6ac063338a6d7bca793f94d/object_rep.diff"
    sha256 "2fef524ac5e319d7092fbb28f6d4e3d3eccd6a570e7789a9b5b0c9a25e714523"
  end

  def install
    ENV["LUA_PATH"] = Formula["lua@5.1"].opt_prefix

    args = %w[release install]
    case ENV.compiler
    when :clang
      args << "--toolset=clang"
    when :gcc
      args << "--toolset=darwin"
    end
    args << "--prefix=#{prefix}"
    system "b2", *args

    (lib/"pkgconfig/luabind.pc").write pc_file
  end

  def pc_file
    <<~EOS
      prefix=#{HOMEBREW_PREFIX}
      exec_prefix=${prefix}
      libdir=${exec_prefix}/lib
      includedir=${exec_prefix}/include

      Name: luabind
      Description: Library for bindings between C++ and Lua
      Version: 0.9.1
      Libs: -L${libdir} -lluabind
      Cflags: -I${includedir}
    EOS
  end

  test do
    (testpath/"hello.cpp").write <<~EOS
      extern "C" {
      #include <lua.h>
      }
      #include <iostream>
      #include <luabind/luabind.hpp>
      void greet() { std::cout << "hello world!\\n"; }
      extern "C" int init(lua_State* L)
      {
          using namespace luabind;
          open(L);
          module(L)
          [
              def("greet", &greet)
          ];
          return 0;
      }
    EOS
    system ENV.cxx, "-shared", "hello.cpp", "-o", "hello.dylib",
                    "-I#{Formula["lua@5.1"].include}/lua-5.1",
                    "-L#{lib}", "-lluabind",
                    "-L#{Formula["lua@5.1"].lib}", "-llua5.1"
    output = `lua5.1 -e "package.loadlib('#{testpath}/hello.dylib', 'init')(); greet()"`
    assert_match "hello world!", output
  end
end
