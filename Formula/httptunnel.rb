class Httptunnel < Formula
  desc "Tunnels a data stream in HTTP requests"
  homepage "https://github.com/larsbrinkhoff/httptunnel"
  url "https://ftp.gnu.org/gnu/httptunnel/httptunnel-3.3.tar.gz"
  mirror "https://ftpmirror.gnu.org/httptunnel/httptunnel-3.3.tar.gz"
  sha256 "142f82b204876c2aa90f19193c7ff78d90bb4c2cba99dfd4ef625864aed1c556"
  license "GPL-2.0-only"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ba3194a2dd8fc577851681cbb058cd2f37b2568697c0bd8117c73e66841d6aa8" => :big_sur
    sha256 "20312eef433095612b34d5e73a3ae27d3198d3a559dddddc6a316844da8cf2c2" => :catalina
    sha256 "cd8ea90f49b98d3cbe213bfd750eb0a095d06a19a4705a9e7e08b153571c27a9" => :mojave
  end

  disable! date: "2020-12-08", because: :unmaintained

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    # The ./configure file inside the tarball is too old to work with Xcode 12, regenerate:
    system "autoreconf", "--verbose", "--install", "--force"
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    pid = fork do
      exec "#{bin}/hts --stdin-stdout --pid-file #{testpath}/pid 8081"
    end
    sleep 2

    begin
      assert_predicate testpath/"pid", :exist?
    ensure
      Process.kill "SIGINT", pid
      Process.wait pid
    end
  end
end
