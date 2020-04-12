class Luvit < Formula
  desc "Asynchronous I/O for Lua"
  homepage "https://luvit.io"
  url "https://github.com/luvit/luvit/archive/2.17.0.tar.gz"
  sha256 "80657aa752322560fcde780212b6807b626b45d65aca3f3dae254e5c4fb0ee78"
  head "https://github.com/luvit/luvit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b057dc9f3afbcc37bd7ed40c9a283928f340af080cf75146d428976f61747535" => :catalina
    sha256 "b057dc9f3afbcc37bd7ed40c9a283928f340af080cf75146d428976f61747535" => :mojave
    sha256 "b057dc9f3afbcc37bd7ed40c9a283928f340af080cf75146d428976f61747535" => :high_sierra
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
