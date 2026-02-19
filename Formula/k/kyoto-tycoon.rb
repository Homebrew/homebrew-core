class KyotoTycoon < Formula
  desc "Database server with interface to Kyoto Cabinet"
  homepage "https://dbmx.net/kyototycoon/"
  url "https://dbmx.net/kyototycoon/pkg/kyototycoon-0.9.56.tar.gz"
  sha256 "553e4ea83237d9153cc5e17881092cefe0b224687f7ebcc406b061b2f31c75c6"
  license "GPL-3.0-or-later"
  revision 5

  livecheck do
    url "https://dbmx.net/kyototycoon/pkg/"
    regex(/href=.*?kyototycoon[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "409039aba15f91854558024a2b4b4e7238164950a0f9aaecd576c0414c9b225b"
    sha256 arm64_sequoia: "8b2c6c299276fdc723900da83356a6fcdad858b663efa0e62b58e82270ea9c1b"
    sha256 arm64_sonoma:  "7558ae59191b5f274713d90d4125549d13731f3565ec4d695a90e2fa6d61c152"
    sha256 sonoma:        "0124e888f1cf8dd1384369bd9d0679cff458c2e6c317655cd36f92ed41191e16"
    sha256 arm64_linux:   "566a096ee78096abada9b56c8589a5a5a5a780e36887ba87fce266925d412499"
    sha256 x86_64_linux:  "2c980249e288c8d49296641182d32f63233d5da165f3a5a70e0d6fff82621385"
  end

  depends_on "lua" => :build
  depends_on "pkgconf" => :build
  depends_on "kyoto-cabinet"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Build patch (submitted upstream)
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/kyoto-tycoon/0.9.56.patch"
    sha256 "7a5efe02a38e3f5c96fd5faa81d91bdd2c1d2ffeb8c3af52878af4a2eab3d830"
  end

  # Homebrew-specific patch to support testing with ephemeral ports (submitted upstream)
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/kyoto-tycoon/ephemeral-ports.patch"
    sha256 "736603b28e9e7562837d0f376d89c549f74a76d31658bf7d84b57c5e66512672"
  end

  def install
    ENV.append_to_cflags "-fpermissive" if OS.linux?
    ENV.append "CXXFLAGS", "-std=c++98"
    system "./configure", "--prefix=#{prefix}",
                          "--with-kc=#{Formula["kyoto-cabinet"].opt_prefix}",
                          "--with-lua=#{Formula["lua"].opt_prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.lua").write <<~LUA
      kt = __kyototycoon__
      db = kt.db
      -- echo back the input data as the output data
      function echo(inmap, outmap)
         for key, value in pairs(inmap) do
            outmap[key] = value
         end
         return kt.RVSUCCESS
      end
    LUA
    port = free_port

    spawn bin/"ktserver", "-port", port.to_s, "-scr", testpath/"test.lua"
    sleep 10

    assert_match "Homebrew\tCool", shell_output("#{bin}/ktremotemgr script -port #{port} echo Homebrew Cool 2>&1")
  end
end
