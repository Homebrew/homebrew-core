class Dqlite < Formula
  desc "Embeddable, replicated and fault-tolerant SQLite-powered engine"
  homepage "https://dqlite.io"
  url "https://github.com/canonical/dqlite/archive/refs/tags/v1.18.7.tar.gz"
  sha256 "7a9087460f3296313379e95a25761c88081c508ae0742bec6fb63e895eb807a9"
  license "LGPL-3.0-only"

  bottle do
    sha256 cellar: :any, arm64_linux:  "c0e0c9554fcc850627af87326fb2485dc44c81857f3300fa1450704390c1fbe7"
    sha256 cellar: :any, x86_64_linux: "6c9b9d13db577239d6131cd0a5475cd7e4353bff7b468c4aa7ee14de8b3917a1"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "go" => :test
  depends_on "libuv"
  depends_on :linux # requires Linux kernel AIO
  depends_on "lz4"
  depends_on "sqlite"

  def install
    ENV["CGO_ENABLED"] = "1" if Hardware::CPU.arm?

    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    ENV["CGO_ENABLED"] = "1" if Hardware::CPU.arm?

    resource "dqlite-demo" do
      url "https://raw.githubusercontent.com/canonical/go-dqlite/2425f137a185a27e2b2fee7c2cb5f97d459e695d/cmd/dqlite-demo/dqlite-demo.go"
      sha256 "302890eb50419e7fee4d8c5dc27a77353ed7e9d9047f65e872def971fd3ef178"
    end

    (testpath/"testproject").mkpath
    (testpath/"testproject").install resource("dqlite-demo")
    cd "testproject" do
      system "go", "mod", "init", "testproject"
      system "go", "mod", "tidy"
      system "go", "build", "-o", "test"

      lo = "127.0.0.1"
      # cluster of 2 instances, 1 db and 1 API port each
      api1 = free_port
      db1 = free_port
      api2 = free_port
      db2 = free_port
      out1 = IO.popen("./test --db #{lo}:#{db1} --api #{lo}:#{api1}")
      sleep 3
      out2 = IO.popen("./test --db #{lo}:#{db2} --api #{lo}:#{api2} --join #{lo}:#{db1}")
      sleep 3
      assert_match "done", shell_output("curl -X PUT -d my-value http://#{lo}:#{api1}/my-key")
      sleep 1
      Process.kill("TERM", out1.pid)
      sleep 1
      assert_match "my-value", shell_output("curl http://#{lo}:#{api2}/my-key")
      Process.kill("TERM", out2.pid)
    end
  end
end
