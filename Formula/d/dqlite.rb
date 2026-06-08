class Dqlite < Formula
  desc "Embeddable, replicated and fault-tolerant SQLite-powered engine"
  homepage "https://dqlite.io"
  url "https://github.com/canonical/dqlite/archive/refs/tags/v1.18.6.tar.gz"
  sha256 "b5db944aa8e0a961716bef66cdfbc0fe328d086667a050e8da14d340a5fa51d4"
  license "LGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "1fd33be56c02ab789eedf0f9bd90a1271a7c581cb3070b8061a348743db7896a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "23c96060d4f46285a1bf2fc030c689ccb08d859481fadd982946fbcee108fc75"
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
