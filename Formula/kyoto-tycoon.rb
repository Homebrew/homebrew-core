class KyotoTycoon < Formula
  desc "Database server with interface to Kyoto Cabinet"
  homepage "https://fallabs.com/kyototycoon/"
  url "https://fallabs.com/kyototycoon/pkg/kyototycoon-0.9.56.tar.gz"
  sha256 "553e4ea83237d9153cc5e17881092cefe0b224687f7ebcc406b061b2f31c75c6"
  license "GPL-3.0-or-later"
  revision 4

  bottle do
    sha256 "2f430dc00ac505a7098596c769cc1c03d6d7a3fdc35ba7bc55fcd707576ac9a2" => :catalina
    sha256 "04d72b5c55be3c26c688eda6c0cc9f88c85855ba6fe81aa36e210fc29afe7572" => :mojave
    sha256 "ce7db5082c632bef982d5463f3a8507d786fd3bcae7f7cccf8663ab36c3571bd" => :high_sierra
    sha256 "e75c60a4417bc00d04e1f24241320329f01b0d3076de2585e92375b12c4ef31d" => :sierra
  end

  depends_on "lua" => :build
  depends_on "pkg-config" => :build
  depends_on "kyoto-cabinet"
  depends_on "zlib"

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
