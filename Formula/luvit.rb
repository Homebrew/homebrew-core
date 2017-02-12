class Luvit < Formula
  desc "Asynchronous I/O for Lua"
  homepage "https://luvit.io"
  url "https://github.com/luvit/luvit/archive/2.12.1.tar.gz"
  sha256 "2de9ee3b22fdf83dbb151e3050a729acce6775258f798bbe4cdcf78c8225acaf"
  head "https://github.com/luvit/luvit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "508bace208f8f33bfb1fc991a13be58db2272f49168064a03321830924db59f1" => :sierra
    sha256 "508bace208f8f33bfb1fc991a13be58db2272f49168064a03321830924db59f1" => :el_capitan
    sha256 "3df87be84fc21729b53b1bda0f30a742531982ad4a36cc0c15650e5d089bfdff" => :yosemite
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
    system bin/"luvit", "--cflags", "--libs"
  end
end
