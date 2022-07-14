# NOTE: We have a policy of building only from tagged commits, but make a
#       singular exception for luajit. This exception will not be extended
#       to other formulae. See:
#       https://github.com/Homebrew/homebrew-core/pull/99580
class Luajit < Formula
  desc "Just-In-Time Compiler (JIT) for the Lua programming language"
  homepage "https://luajit.org/luajit.html"
  # Update this to the tip of the `v2.1` branch at the start of every month.
  url "https://github.com/LuaJIT/LuaJIT/archive/50936d784474747b4569d988767f1b5bab8bb6d0.tar.gz"
  # Use the version scheme `2.1.0-beta3-yyyymmdd.x` where `yyyymmdd` is the date of the
  # latest commit at the time of updating, and `x` is the number of commits on that date.
  version "2.1.0-beta3-20220712.6"
  sha256 "4d44e4709130b031c1c2c81cf5c102dfce877bf454409dabba03249e18870e66"
  license "MIT"
  head "https://luajit.org/git/luajit-2.0.git", branch: "v2.1"

  livecheck do
    url "https://github.com/LuaJIT/LuaJIT/commits/v2.1"
    regex(/<relative-time[^>]+?datetime=["']?(\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z)["' >]/im)
    strategy :page_match do |page, regex|
      newest_date = nil
      commit_count = 0
      page.scan(regex).map do |match|
        date = Date.parse(match[0])
        newest_date ||= date
        break if date != newest_date

        commit_count += 1
      end
      next if newest_date.blank? || commit_count.zero?

      # The main LuaJIT version is rarely updated, so we recycle it from the
      # `version` to avoid having to fetch another page.
      version.to_s.sub(/\d+\.\d+$/, "#{newest_date.strftime("%Y%m%d")}.#{commit_count}")
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "519a2e60557c73f7a181727d69aa7d94007afa7d6041b823c867790d80313176"
    sha256 cellar: :any,                 arm64_big_sur:  "09f3f32a0869b6ed81c250f66b1ed6a5d9d4db8fd8e0b25c8b2ad6a7b7be343e"
    sha256 cellar: :any,                 monterey:       "d7796f1663ba457d6deb7a19cfaea8be8a21d8064d73fb13196480bc307708fc"
    sha256 cellar: :any,                 big_sur:        "2182294caa7cf5589ebb5d6862e5eaa0fa367f697f95b44058f59f57db5b524c"
    sha256 cellar: :any,                 catalina:       "ddc9c0063bb5d8d47ece519063e118983a9b0c9b5add83c9dafc0dcb5c59682a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95a5d53908af9ce0abe23dbe82df20bdeac624ffe7d2e84b8d92b89aebd76e9c"
  end

  def install
    # https://github.com/LuaJIT/LuaJIT/issues/648#issuecomment-752023149
    ENV.runtime_cpu_detection

    # 1 - Override the hardcoded gcc.
    # 2 - Remove the "-march=i686" so we can set the march in cflags.
    # Both changes should persist and were discussed upstream.
    # Also: Set `LUA_ROOT` to `HOMEBREW_PREFIX` so that Luajit can find modules outside its own keg.
    # This should avoid the need for writing env scripts that specify `LUA_PATH` or `LUA_CPATH`.
    inreplace "src/Makefile" do |f|
      f.change_make_var! "CC", ENV.cc
      f.gsub!(/-march=\w+\s?/, "")
      f.gsub!(/^(  TARGET_XCFLAGS\+= -DLUA_ROOT=)\\"\$\(PREFIX\)\\"$/, "\\1\\\"#{HOMEBREW_PREFIX}\\\"")
    end

    # Per https://luajit.org/install.html: If MACOSX_DEPLOYMENT_TARGET
    # is not set then it's forced to 10.4, which breaks compile on Mojave.
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

    # Pass `Q=` to build verbosely.
    system "make", "amalg", "PREFIX=#{prefix}", "Q="
    system "make", "install", "PREFIX=#{prefix}", "Q="

    # We need `stable.version` here to avoid breaking symlink generation for HEAD.
    upstream_version = stable.version.to_s.sub(/-\d+\.\d+$/, "")
    # v2.1 branch doesn't install symlink for luajit.
    # This breaks tools like `luarocks` that require the `luajit` bin to be present.
    bin.install_symlink "luajit-#{upstream_version}" => "luajit"

    # LuaJIT doesn't automatically symlink unversioned libraries:
    # https://github.com/Homebrew/homebrew/issues/45854.
    lib.install_symlink lib/shared_library("libluajit-5.1") => shared_library("libluajit")
    lib.install_symlink lib/"libluajit-5.1.a" => "libluajit.a"

    # Fix path in pkg-config so modules are installed
    # to permanent location rather than inside the Cellar.
    inreplace lib/"pkgconfig/luajit.pc" do |s|
      s.gsub! "INSTALL_LMOD=${prefix}/share/lua/${abiver}",
              "INSTALL_LMOD=#{HOMEBREW_PREFIX}/share/lua/${abiver}"
      s.gsub! "INSTALL_CMOD=${prefix}/${multilib}/lua/${abiver}",
              "INSTALL_CMOD=#{HOMEBREW_PREFIX}/${multilib}/lua/${abiver}"
    end
  end

  test do
    system bin/"luajit", "-e", <<~EOS
      local ffi = require("ffi")
      ffi.cdef("int printf(const char *fmt, ...);")
      ffi.C.printf("Hello %s!\\n", "#{ENV["USER"]}")
    EOS

    # Check that LuaJIT can find its own `jit.*` modules
    touch "empty.lua"
    system bin/"luajit", "-b", "empty.lua", "empty.o"
    assert_predicate testpath/"empty.o", :exist?
  end
end
