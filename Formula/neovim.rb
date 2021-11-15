class Neovim < Formula
  desc "Ambitious Vim-fork focused on extensibility and agility"
  homepage "https://neovim.io/"
  url "https://github.com/neovim/neovim/archive/v0.5.1.tar.gz"
  sha256 "aa449795e5cc69bdd2eeed7095f20b9c086c6ecfcde0ab62ab97a9d04243ec84"
  license "Apache-2.0"
  revision 1
  head "https://github.com/neovim/neovim.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "db5ecc86bb0390196da86291fe1ae7dec9f8c7e3c31e63ca92cd4376d41dc68f"
    sha256 arm64_big_sur:  "d18b2beaa1c98eb011ab6706e6ad5db6e991d30b9d11611f17cac5c7c2eb4dbe"
    sha256 monterey:       "1c9c88c778bd5033c72e30a1421ded01517b21982885ab5c0b1d7652a41d95aa"
    sha256 big_sur:        "f58c80dc75a3a255df1704d4b6ef4ef2cfafd27149d61bb97d278f20e7c5a731"
    sha256 catalina:       "d5a78c8f649c01e238997ab65f2b4782378fc0374f37b8ca4749b793c8a4bf86"
    sha256 x86_64_linux:   "b302d18def6baf4e3b18ef0ea407183b0d0c694492d40e6a72ae02a52943c35f"
  end

  depends_on "cmake" => :build
  # Libtool is needed to build `libvterm`.
  # Remove this dependency when we use the formula.
  depends_on "libtool" => :build
  depends_on "luarocks" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "libtermkey"
  depends_on "libuv"
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

  # TODO: Use `libvterm` formula when the following is resolved:
  # https://github.com/neovim/neovim/pull/16219
  resource "libvterm" do
    url "http://www.leonerd.org.uk/code/libvterm/libvterm-0.1.4.tar.gz"
    sha256 "bc70349e95559c667672fc8c55b9527d9db9ada0fb80a3beda533418d782d3dd"
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
      r.stage(buildpath/"deps-build/build/src"/r.name)
    end

    ENV.prepend_path "LUA_PATH", "#{buildpath}/deps-build/share/lua/5.1/?.lua"
    ENV.prepend_path "LUA_CPATH", "#{buildpath}/deps-build/lib/lua/5.1/?.so"
    lua_path = "--lua-dir=#{Formula["luajit-openresty"].opt_prefix}"

    cd "deps-build/build/src" do
      %w[
        mpack/mpack-1.0.8-0.rockspec
        lpeg/lpeg-1.0.2-1.src.rock
      ].each do |rock|
        dir, rock = rock.split("/")
        cd dir do
          output = Utils.safe_popen_read("luarocks", "unpack", lua_path, rock, "--tree=#{buildpath}/deps-build")
          unpack_dir = output.split("\n")[-2]
          cd unpack_dir do
            system "luarocks", "make", lua_path, "--tree=#{buildpath}/deps-build"
          end
        end
      end

      # Build libvterm. Remove when we use the formula.
      cd "libvterm" do
        system "make", "install", "PREFIX=#{buildpath}/deps-build", "LDFLAGS=-static #{ENV.ldflags}"
        ENV.prepend_path "PKG_CONFIG_PATH", buildpath/"deps-build/lib/pkgconfig"
      end
    end

    system "cmake", "-S", ".", "-B", "build",
                    "-DLIBLUV_LIBRARY=#{Formula["luv"].opt_lib/shared_library("libluv")}",
                    *std_cmake_args

    # Patch out references to Homebrew shims
    inreplace "build/config/auto/versiondef.h", Superenv.shims_path/ENV.cc, ENV.cc

    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.txt").write("Hello World from Vim!!")
    system bin/"nvim", "--headless", "-i", "NONE", "-u", "NONE",
                       "+s/Vim/Neovim/g", "+wq", "test.txt"
    assert_equal "Hello World from Neovim!!", (testpath/"test.txt").read.chomp
  end
end
