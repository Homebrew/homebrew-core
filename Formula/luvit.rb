class Luvit < Formula
  desc "Asynchronous I/O for Lua"
  homepage "https://luvit.io"
  url "https://github.com/luvit/luvit/archive/2.16.0.tar.gz"
  sha256 "3cbd5136da6dba4ccfaee86357255c39b5fafa5fffa62d7d793514fa4dca1a79"
  head "https://github.com/luvit/luvit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c03ecdd024a87886e263e4e02cfd463ec6e45ca1f36bc40b4cea7fc8633f5d2e" => :mojave
    sha256 "c03ecdd024a87886e263e4e02cfd463ec6e45ca1f36bc40b4cea7fc8633f5d2e" => :high_sierra
    sha256 "44b88d13dec6b1646ae0c957c63c8513f4caa73585cbc93c711a88e8310a7d31" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "luajit"
  depends_on "openssl"

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
