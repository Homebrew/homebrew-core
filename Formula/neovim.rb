class Neovim < Formula
  desc "Ambitious Vim-fork focused on extensibility and agility"
  homepage "https://neovim.io/"
  license "Apache-2.0"
  revision 1
  head "https://github.com/neovim/neovim.git", branch: "master"

  # Remove `stable` block when `gperf` is no longer needed.
  stable do
    url "https://github.com/neovim/neovim/archive/v0.7.2.tar.gz"
    sha256 "ccab8ca02a0c292de9ea14b39f84f90b635a69282de38a6b4ccc8565bc65d096"
    # GPerf was removed in https://github.com/neovim/neovim/pull/18544.
    # Remove dependency when relevant commits are in a stable release.
    uses_from_macos "gperf" => :build
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "dfa6e9cd76254d80db19a326efae6ea17e0285b003916495238422b0b8490cc1"
    sha256 arm64_big_sur:  "113cc688142c0498e7eb6c85291d5ecbf61787def7054c522338a24be6fc8c24"
    sha256 monterey:       "14416b842e0647842fef57ee8a021cc991a4d400e4f691a1b140dbba62ad6adc"
    sha256 big_sur:        "092d5ebab04ea0c1c2f24d27ecdeada51d84702e572dae9c1b0dd56042514e73"
    sha256 catalina:       "aab60ed55c32ec01e4d96e5967bc034d2ac80021cad4cfd1833281678c9b120c"
    sha256 x86_64_linux:   "c35e33e2f7e8f9d97b2eada22bb9fa00d1ba75414150db03547d3d2337f3a4bb"
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
  depends_on "luajit"
  depends_on "luv"
  depends_on "msgpack"
  depends_on "tree-sitter"
  depends_on "unibilium"

  uses_from_macos "unzip" => :build

  on_linux do
    depends_on "libnsl"
  end

  # TODO: Use `libvterm` formula when the following is resolved:
  # https://github.com/neovim/neovim/pull/16219
  resource "libvterm" do
    url "https://www.leonerd.org.uk/code/libvterm/libvterm-0.1.4.tar.gz"
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

    # The path separator for `LUA_PATH` and `LUA_CPATH` is `;`.
    ENV.prepend "LUA_PATH", buildpath/"deps-build/share/lua/5.1/?.lua", ";"
    ENV.prepend "LUA_CPATH", buildpath/"deps-build/lib/lua/5.1/?.so", ";"
    # Don't clobber the default search path
    ENV.append "LUA_PATH", ";", ";"
    ENV.append "LUA_CPATH", ";", ";"
    lua_path = "--lua-dir=#{Formula["luajit"].opt_prefix}"

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

    # Point system locations inside `HOMEBREW_PREFIX`.
    inreplace "src/nvim/os/stdpaths.c" do |s|
      s.gsub! "/etc/xdg/", "#{etc}/xdg/:\\0"

      unless HOMEBREW_PREFIX.to_s == HOMEBREW_DEFAULT_PREFIX
        s.gsub! "/usr/local/share/:/usr/share/", "#{HOMEBREW_PREFIX}/share/:\\0"
      end
    end

    system "cmake", "-S", ".", "-B", "build",
                    "-DLIBLUV_LIBRARY=#{Formula["luv"].opt_lib/shared_library("libluv")}",
                    "-DLIBUV_LIBRARY=#{Formula["libuv"].opt_lib/shared_library("libuv")}",
                    *std_cmake_args

    # Patch out references to Homebrew shims
    # TODO: Remove conditional when the following PR is included in a release.
    # https://github.com/neovim/neovim/pull/19120
    config_dir_prefix = build.head? ? "cmake." : ""
    inreplace "build/#{config_dir_prefix}config/auto/versiondef.h", Superenv.shims_path/ENV.cc, ENV.cc

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
