class Neovim < Formula
  desc "Ambitious Vim-fork focused on extensibility and agility"
  homepage "https://neovim.io/"
  url "https://github.com/neovim/neovim/archive/v0.5.1.tar.gz"
  sha256 "aa449795e5cc69bdd2eeed7095f20b9c086c6ecfcde0ab62ab97a9d04243ec84"
  license "Apache-2.0"
  head "https://github.com/neovim/neovim.git", branch: "master"

  bottle do
    sha256 arm64_big_sur: "bf8f8dc4407dadb55f81ca0d920d9473c12fc5ec88107e5845e61a61f9f02cdc"
    sha256 big_sur:       "0cdce2ddbece563e47ad2734cf181fbea53a8a4c85fc9943f31ea537b5a0e313"
    sha256 catalina:      "13516e756e516d44279ecfba5aa50395d12c176be2fa4da5c7c39580bde87e9d"
    sha256 mojave:        "8f905a82a928ae7ae41b4d46c409bbf6b6a9c11a2d5edea2ee723315d4b31361"
    sha256 x86_64_linux:  "77090b199f345cf0ab8e1f81814b659136de6a85451278ceb22a0712fbfa90c4"
  end

  depends_on "cmake" => :build
  depends_on "luarocks" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "libtermkey"
  depends_on "libuv"
  depends_on "libvterm"
  depends_on "luajit-openresty"
  depends_on "luv"
  depends_on "msgpack"
  depends_on "tree-sitter"
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

  def install
    resources.each do |r|
      r.stage(buildpath/"deps-build/build/src/#{r.name}")
    end

    ENV.prepend_path "LUA_PATH", "#{buildpath}/deps-build/share/lua/5.1/?.lua"
    ENV.prepend_path "LUA_CPATH", "#{buildpath}/deps-build/lib/lua/5.1/?.so"
    lua_path = "--lua-dir=#{Formula["luajit-openresty"].opt_prefix}"

    cd "deps-build" do
      %w[
        mpack/mpack-1.0.8-0.rockspec
        lpeg/lpeg-1.0.2-1.src.rock
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
      system "cmake", "..", *std_cmake_args, "-DLIBLUV_LIBRARY=#{Formula["luv"].opt_lib/shared_library("libluv")}"
      # Patch out references to Homebrew shims
      inreplace "config/auto/versiondef.h", Superenv.shims_path/ENV.cc, ENV.cc
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
