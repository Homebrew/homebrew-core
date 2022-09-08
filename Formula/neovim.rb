class Neovim < Formula
  desc "Ambitious Vim-fork focused on extensibility and agility"
  homepage "https://neovim.io/"
  license "Apache-2.0"
  revision 1

  # Remove `stable` block when `gperf` is no longer needed.
  stable do
    url "https://github.com/neovim/neovim/archive/v0.7.2.tar.gz"
    sha256 "ccab8ca02a0c292de9ea14b39f84f90b635a69282de38a6b4ccc8565bc65d096"

    # Libtool is needed to build `libvterm`.
    # Remove this dependency when we use the formula.
    depends_on "libtool" => :build
    # GPerf was removed in https://github.com/neovim/neovim/pull/18544.
    # Remove dependency when relevant commits are in a stable release.
    uses_from_macos "gperf" => :build

    # TODO: Use `libvterm` formula when the following is released:
    # https://github.com/neovim/neovim/pull/17329
    resource "libvterm" do
      url "https://www.leonerd.org.uk/code/libvterm/libvterm-0.1.4.tar.gz"
      sha256 "bc70349e95559c667672fc8c55b9527d9db9ada0fb80a3beda533418d782d3dd"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_monterey: "94d4c819d426aad050bfcf17fabc3debc053911fcbed214a04a4dbbce0d1bece"
    sha256 arm64_big_sur:  "82daa8d3738bd331a6f9afa52989b12b98d8038ca03f83ddcbb0be6f3e033fbf"
    sha256 monterey:       "fedc9b9ffdaaf160d4f91ed88a9532c696d1b3226b347e96afe9e54089d4832e"
    sha256 big_sur:        "463dc2636ebd9ce5d0f44369dddbd3d5715dc00466a4869e282d0c8dc2f565ee"
    sha256 catalina:       "b9f6078ef504308896213a3e979733ccb93dca8c4873a8c686b6d3f607fcd8d8"
    sha256 x86_64_linux:   "be762f679f83c41fb982d32f067229ca3480f991fdcbc7b15147fdef932312a1"
  end

  # Remove `head` block when `stable` depends on `libvterm`.
  head do
    url "https://github.com/neovim/neovim.git", branch: "master"
    depends_on "libvterm"
  end

  depends_on "cmake" => :build
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

      if build.stable?
        # Build libvterm. Remove when we use the formula.
        cd "libvterm" do
          system "make", "install", "PREFIX=#{buildpath}/deps-build", "LDFLAGS=-static #{ENV.ldflags}"
          ENV.prepend_path "PKG_CONFIG_PATH", buildpath/"deps-build/lib/pkgconfig"
        end
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

  def caveats
    return if latest_head_version.blank?

    <<~EOS
      HEAD installs of Neovim do not include any tree-sitter parsers.
      You can use the `nvim-treesitter` plugin to install them.
    EOS
  end

  test do
    (testpath/"test.txt").write("Hello World from Vim!!")
    system bin/"nvim", "--headless", "-i", "NONE", "-u", "NONE",
                       "+s/Vim/Neovim/g", "+wq", "test.txt"
    assert_equal "Hello World from Neovim!!", (testpath/"test.txt").read.chomp
  end
end
