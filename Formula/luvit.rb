class Luvit < Formula
  desc "Asynchronous I/O for Lua"
  homepage "https://luvit.io"
  url "https://github.com/luvit/luvit/archive/2.17.0.tar.gz"
  sha256 "80657aa752322560fcde780212b6807b626b45d65aca3f3dae254e5c4fb0ee78"
  license "Apache-2.0"
  head "https://github.com/luvit/luvit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a1210dda91aa024d11bd4d15a67b71654dcbbbc2ba14a87d1d34ab012f4d5c2a" => :catalina
    sha256 "a3a37fdf8f0e99efdfc1736978ea9d8cdea74e939b42696fe771c3c5c9914f8f" => :mojave
    sha256 "2c704b1f98b965c0b6010a897a0c951f47cb896bbbf5381e7d4ee80238692033" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "luajit"
  depends_on "openssl@1.1"

  def install
    ENV["USE_SYSTEM_SSL"] = "1"
    ENV["USE_SYSTEM_LUAJIT"] = "1"
    ENV["PREFIX"] = prefix
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "Hello World\n", shell_output("#{bin}/luvit -e 'print(\"Hello World\")'")
  end
end
