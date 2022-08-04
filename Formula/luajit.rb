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
  url "https://github.com/LuaJIT/LuaJIT/archive/a7d0265480c662964988f83d4e245bf139eb7cc0.tar.gz"
  # Use the version scheme `2.1.0-beta3-yyyymmdd.x` where `yyyymmdd` is the date of the
  # latest commit at the time of updating, and `x` is the number of commits on that date.
  # `brew livecheck luajit` will generate the correct version for you automatically.
  version "2.1.0-beta3-20220728.2"
  sha256 "7d7f58ca5c02b453ed4ddd2298e741053cbd6cd3d96e79460d06ec6684244c59"
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
    sha256 cellar: :any,                 arm64_monterey: "b89e5a7a1fbd4b5d44d45fdfefb4612d932557cfdcc0db43ea7c89ad07e317a3"
    sha256 cellar: :any,                 arm64_big_sur:  "bd6abf64656efeff40ad81ec2bc1123ca0c642dd99f07a7c7e68433cc6b3f03a"
    sha256 cellar: :any,                 monterey:       "a89bae71896c0e4c17a0832ee7aea3914ced8bb5c38aaed5ad52d3d802cfea64"
    sha256 cellar: :any,                 big_sur:        "daa162fc47e6ac409532028fb3fd4722cf8593fa594bc06130f4a01f69861572"
    sha256 cellar: :any,                 catalina:       "e2f445593b813dfb9380ea2c74d499b7dda5d5079a9c9660a1e995d271931276"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "502da7082ed0259e3e34b95e68a44024f6281f7a56ade5db0b11e2d240b66b7c"
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
