# NOTE: We have a policy of building only from tagged commits, but make a
#       singular exception for luajit. This exception will not be extended
#       to other formulae. See:
#       https://github.com/Homebrew/homebrew-core/pull/99580
# TODO: Add an audit in `brew` for this. https://github.com/Homebrew/homebrew-core/pull/104765
class Luajit < Formula
  desc "Just-In-Time Compiler (JIT) for the Lua programming language"
  homepage "https://luajit.org/luajit.html"
  # Update this to the tip of the `v2.1` branch at the start of every month.
  # Get the latest commit with:
  #   `git ls-remote --heads https://github.com/LuaJIT/LuaJIT.git v2.1`
  url "https://github.com/LuaJIT/LuaJIT/archive/505e2c03de35e2718eef0d2d3660712e06dadf1f.tar.gz"
  # Use the version scheme `2.1.0-beta3-yyyymmdd.x` where `yyyymmdd` is the date of the
  # latest commit at the time of updating, and `x` is the number of commits on that date.
  # `brew livecheck luajit` will generate the correct version for you automatically.
  version "2.1.0-beta3-20230221.4"
  sha256 "67c88399b901a22e9a236f4b77e6fe39af00f6b7144ce9dd6f51141d921f1076"
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
    sha256 cellar: :any,                 arm64_ventura:  "d9569bbad3c273769c5ec51a25c5c65e3e95bc126a7e2587726a5c16ccafddb2"
    sha256 cellar: :any,                 arm64_monterey: "2afb55fd9c63fae6edb1f897c2d73d8b6bbd9cd8b608f8b82fcde5d3aaeb24a7"
    sha256 cellar: :any,                 arm64_big_sur:  "28c799a9775846240ad76bc72980a28de232f9fa78dcc17b0f98ac87d610c06c"
    sha256 cellar: :any,                 ventura:        "a6a3f0eb5d8f867ca003ccd81bf13686c2dca16fa7f8d2b96aa366c840206bfc"
    sha256 cellar: :any,                 monterey:       "68c74b51dab29df0c0fb8a65bb16da65c9fa71eb5648fbfbb68a7fbb0b7b3991"
    sha256 cellar: :any,                 big_sur:        "1b8a935963b449ecdd87677e31de55d2b9eda1f4de77aeaa2cffe11c579b0c69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6349b72d106c198f7022561d123d3f96eb70c9ee8033ca41e860ca173f13df2a"
  end

  def install
    # 1 - Override the hardcoded gcc.
    # 2 - Remove the "-march=i686" so we can set the march in cflags.
    # Both changes should persist and were discussed upstream.
    inreplace "src/Makefile" do |f|
      f.change_make_var! "CC", ENV.cc
      f.gsub!(/-march=\w+\s?/, "")
    end

    # Per https://luajit.org/install.html: If MACOSX_DEPLOYMENT_TARGET
    # is not set then it's forced to 10.4, which breaks compile on Mojave.
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

    # Pass `Q= E=@:` to build verbosely.
    verbose_args = %w[Q= E=@:]

    # Build with PREFIX=$HOMEBREW_PREFIX so that luajit can find modules outside its own keg.
    # This allows us to avoid having to set `LUA_PATH` and `LUA_CPATH` for non-vendored modules.
    system "make", "amalg", "PREFIX=#{HOMEBREW_PREFIX}", *verbose_args
    system "make", "install", "PREFIX=#{prefix}", *verbose_args
    doc.install (buildpath/"doc").children

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
    system bin/"luajit", "-b", "-o", "osx", "-a", "arm64", "empty.lua", "empty.o"
    assert_predicate testpath/"empty.o", :exist?

    # Check that we're not affected by https://github.com/LuaJIT/LuaJIT/issues/865.
    require "macho"
    machobj = MachO.open("empty.o")
    assert_kind_of MachO::FatFile, machobj
    assert_predicate machobj, :object?

    cputypes = machobj.machos.map(&:cputype)
    assert_includes cputypes, :arm64
    assert_includes cputypes, :x86_64
    assert_equal 2, cputypes.length
  end
end
