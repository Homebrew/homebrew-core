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

  bottle do
    sha256 arm64_ventura:  "29d41775017c933fc6c6298daf48ea1d0e6c5b7158fb323f461e42672549ccc6"
    sha256 arm64_monterey: "887e108eab14901d52e4e0a8b6553bc9a4bf8dc04ae7814e0aa25da08492fec4"
    sha256 arm64_big_sur:  "244a150072e722f1ee861425fdfd1cb12a6a09ee27899b998b0794bd01cd1f12"
    sha256 ventura:        "147129037cdc09136b01f8dc8ca155c968ba9a4a9b9b0e980bc65b4df970a556"
    sha256 monterey:       "01ea2b5572500293e6d2be3fc51d8852a3be3e0a6a0a918f11224a39d5e0d133"
    sha256 big_sur:        "30c5a805f4e4f672814b210a28567424b23af490a8d9555286dae17ee41506c4"
    sha256 catalina:       "575c025f8a4479503833b3d90c8054ed3b67e8f4a14a96978ec585a76bbf7963"
    sha256 mojave:         "aafcc936bd17bade9714e200c0e713ec4cd6ddc8f38a08d258cbf09437adec75"
    sha256 x86_64_linux:   "bb1a1af50e64ab1cf5d39182e0ea8ef10869ecf4f995fd7b6fc31969dab97c9b"
  end

  depends_on "lua" => :build
  depends_on "pkg-config" => :build
  depends_on "kyoto-cabinet"

  uses_from_macos "zlib"

  # Build patch (submitted upstream)
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/955ce09/kyoto-tycoon/0.9.56.patch"
    sha256 "7a5efe02a38e3f5c96fd5faa81d91bdd2c1d2ffeb8c3af52878af4a2eab3d830"
  end

  # Homebrew-specific patch to support testing with ephemeral ports (submitted upstream)
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/9925c07/kyoto-tycoon/ephemeral-ports.patch"
    sha256 "736603b28e9e7562837d0f376d89c549f74a76d31658bf7d84b57c5e66512672"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-kc=#{Formula["kyoto-cabinet"].opt_prefix}",
                          "--with-lua=#{Formula["lua"].opt_prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.lua").write <<~EOS
      kt = __kyototycoon__
      db = kt.db
      -- echo back the input data as the output data
      function echo(inmap, outmap)
         for key, value in pairs(inmap) do
            outmap[key] = value
         end
         return kt.RVSUCCESS
      end
    EOS
    port = free_port

    fork do
      exec bin/"ktserver", "-port", port.to_s, "-scr", testpath/"test.lua"
    end
    sleep 5

    assert_match "Homebrew\tCool", shell_output("#{bin}/ktremotemgr script -port #{port} echo Homebrew Cool 2>&1")
  end
end
