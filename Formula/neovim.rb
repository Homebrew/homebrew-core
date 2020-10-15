class Neovim < Formula
  desc "Ambitious Vim-fork focused on extensibility and agility"
  homepage "https://neovim.io/"
  url "https://github.com/neovim/neovim/archive/v0.4.4.tar.gz"
  sha256 "2f76aac59363677f37592e853ab2c06151cca8830d4b3fe4675b4a52d41fc42c"
  license "Apache-2.0"

  bottle do
    sha256 "ade03fcf189ccd82e8b4627499113aed67a753b0e3ffa9662c15d7037f6ed617" => :catalina
    sha256 "e68135735b24df7e1318bb71c4fef6461884b2c7a166d756b4a21bd787a329a2" => :mojave
    sha256 "77773fc6e8ad7fd726e881850712f3995feef94548bfd6081599c5b682eb4411" => :high_sierra
  end

  head do
    url "https://github.com/neovim/neovim.git"
    depends_on "utf8proc"
  end

  depends_on "cmake" => :build
  depends_on "luarocks" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "libtermkey"
  depends_on "libuv"
  depends_on "libvterm"
  depends_on "luajit"
  depends_on "msgpack"
  depends_on "unibilium"

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

  resource "lua-compat-5.3" do
    url "https://github.com/keplerproject/lua-compat-5.3/archive/v0.7.tar.gz"
    sha256 "bec3a23114a3d9b3218038309657f0f506ad10dfbc03bb54e91da7e5ffdba0a2"
  end

  resource "luv" do
    url "https://github.com/luvit/luv/releases/download/1.30.0-0/luv-1.30.0-0.tar.gz"
    sha256 "5cc75a012bfa9a5a1543d0167952676474f31c2d7fd8d450b56d8929dbebb5ef"
  end

  def install
    resources.each do |r|
      r.stage(buildpath/"deps-build/build/src/#{r.name}")
    end

    ENV.prepend_path "LUA_PATH", "#{buildpath}/deps-build/share/lua/5.1/?.lua"
    ENV.prepend_path "LUA_CPATH", "#{buildpath}/deps-build/lib/lua/5.1/?.so"
    lua_path = "--lua-dir=#{Formula["luajit"].opt_prefix}"

    cmake_compiler_args = %w[
      -DCMAKE_C_COMPILER=/usr/bin/clang
      -DCMAKE_CXX_COMPILER=/usr/bin/clang++
    ]

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

      cd "build/src/luv" do
        cmake_args = std_cmake_args.reject { |s| s["CMAKE_INSTALL_PREFIX"] }
        cmake_args += cmake_compiler_args
        cmake_args += %W[
          -DCMAKE_INSTALL_PREFIX=#{buildpath}/deps-build
          -DLUA_BUILD_TYPE=System
          -DWITH_SHARED_LIBUV=ON
          -DBUILD_SHARED_LIBS=OFF
          -DBUILD_MODULE=OFF
          -DLUA_COMPAT53_DIR=#{buildpath}/deps-build/build/src/lua-compat-5.3
        ]
        system "cmake", ".", *cmake_args
        system "make", "install"
      end
    end

    mkdir "build" do
      cmake_args = std_cmake_args
      cmake_args += cmake_compiler_args
      cmake_args += %W[
        -DLIBLUV_INCLUDE_DIR=#{buildpath}/deps-build/include
        -DLIBLUV_LIBRARY=#{buildpath}/deps-build/lib/libluv.a
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
