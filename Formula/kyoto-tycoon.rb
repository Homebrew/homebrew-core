class KyotoTycoon < Formula
  desc "Database server with interface to Kyoto Cabinet"
  homepage "https://fallabs.com/kyototycoon/"
  url "https://fallabs.com/kyototycoon/pkg/kyototycoon-0.9.56.tar.gz"
  sha256 "553e4ea83237d9153cc5e17881092cefe0b224687f7ebcc406b061b2f31c75c6"
  license "GPL-3.0-or-later"
  revision 4

  bottle do
    sha256 "6718c70e1a6f9095077180661a2fb9649e3c7f36847738ef900bd5565cefb4af" => :big_sur
    sha256 "ec2db363d2e03749d1d738ba77750e86c77b8362725767661b46a54ba88e6a6f" => :arm64_big_sur
    sha256 "fb28428ef7f62c2ac86f78e00101ca58940fe875d4c4a0df5cada4cca8dce7a6" => :catalina
    sha256 "2272eabbc069a844c838aaa501285b475037ebe8a76e1bf1f41ab36974bc035d" => :mojave
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
