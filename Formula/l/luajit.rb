# NOTE: We have a policy of building only from tagged commits, but make a
#       singular exception for luajit. This exception will not be extended
#       to other formulae. See:
#       https://github.com/Homebrew/homebrew-core/pull/99580
# TODO: Add an audit in `brew` for this. https://github.com/Homebrew/homebrew-core/pull/104765
class Luajit < Formula
  desc "Just-In-Time Compiler (JIT) for the Lua programming language"
  homepage "https://luajit.org/luajit.html"
  # Update this to the tip of the `v2.1` branch.
  # Get the latest commit with:
  #   `git ls-remote --heads https://github.com/LuaJIT/LuaJIT.git v2.1`
  # This is a rolling release model so take care not to ignore CI failures that may be regressions.
  url "https://github.com/LuaJIT/LuaJIT/archive/2460b3ff93a1c955de3d62cfc825de7d68dc272e.tar.gz"
  # Use the version scheme `2.1.timestamp` where `timestamp` is the Unix timestamp of the
  # latest commit at the time of updating.
  # `brew livecheck luajit` will generate the correct version for you automatically.
  version "2.1.1784580905"
  sha256 "5c52d06876d86aa199f9b8cdc65f6f9ac086fdfa8a4489ebf8dc4516e194550b"
  license "MIT"
  compatibility_version 20
  head "https://github.com/LuaJIT/LuaJIT.git", branch: "v2.1"

  livecheck do
    url "https://api.github.com/repos/LuaJIT/LuaJIT/branches/v2.1"
    strategy :json do |json|
      date = json.dig("commit", "commit", "author", "date")
      "2.1.#{DateTime.parse(date).strftime("%s")}"
    end
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c2503434b9b8819edf7cbdf22fd44da9b8a3f39fd2241b7cacf67a3129b2a84f"
    sha256 cellar: :any, arm64_sequoia: "c21a240c4e298337875bda9d3356d8c37f4e89ad0cd6436626fba19859c0d42d"
    sha256 cellar: :any, arm64_sonoma:  "d89b3a2b5a4929ffdd41699ef6925c20f34b97ca70aa1e3910c1fe09fd75f29e"
    sha256 cellar: :any, sonoma:        "dc0c0a1163ad06fe3a904876318ce33a078ea844840f7110ea7921e840aaccf8"
    sha256 cellar: :any, arm64_linux:   "cbbba6bf66adaf6dce8d22fb9a3f204d941f243ba68a8eacbd74d0c9723b7c07"
    sha256 cellar: :any, x86_64_linux:  "9e6adac9e4edef850c6c4a69ea96b5543c323d69c469abd18422df614b6f5230"
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
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version.to_s if OS.mac?

    # Help the FFI module find Homebrew-installed libraries.
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath(target: HOMEBREW_PREFIX/"lib")}"

    # Pass `Q= E=@:` to build verbosely.
    verbose_args = %w[Q= E=@:]

    # Build with PREFIX=$HOMEBREW_PREFIX so that luajit can find modules outside its own keg.
    # This allows us to avoid having to set `LUA_PATH` and `LUA_CPATH` for non-vendored modules.
    system "make", "amalg", "PREFIX=#{HOMEBREW_PREFIX}", *verbose_args
    system "make", "install", "PREFIX=#{prefix}", *verbose_args
    doc.install (buildpath/"doc").children

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
    assert_includes shell_output("#{bin}/luajit -v"), " #{version} "

    system bin/"luajit", "-e", <<~LUA
      local ffi = require("ffi")
      ffi.cdef("int printf(const char *fmt, ...);")
      ffi.C.printf("Hello %s!\\n", "#{ENV["USER"]}")
    LUA

    # Check that LuaJIT can find its own `jit.*` modules
    touch "empty.lua"
    system bin/"luajit", "-b", "-o", "osx", "empty.lua", "empty.o"
    assert_path_exists testpath/"empty.o"

    # Check that we're not affected by LuaJIT/LuaJIT/issues/865.
    require "macho"
    machobj = MachO.open("empty.o")
    # always generate 64 bit non-FAT Mach-O object files
    # per https://github.com/LuaJIT/LuaJIT/commit/7110b935672489afd6ba3eef3e5139d2f3bd05b6
    assert_kind_of MachO::MachOFile, machobj
    assert_predicate machobj, :object?
    assert_equal Hardware::CPU.arch, machobj.cputype
  end
end
