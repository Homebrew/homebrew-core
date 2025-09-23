class Memcacheq < Formula
  desc "Queue service for memcache"
  homepage "https://github.com/stvchu/memcacheq"
  url "https://github.com/stvchu/memcacheq/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "ace33313568959b5a301dda491f63af09793987b73fd15abd3fb613829eda07e"
  license "BSD-3-Clause"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "657efc2a568e13bb0f9d2197f5cb084e56c1c55aa99cc62d45e51d199ffb0a93"
    sha256 cellar: :any,                 arm64_sequoia: "2fb49de889de4fa7c037d8b01d7c75a5bc1f8e2ba57658fa6a936d108f2155fb"
    sha256 cellar: :any,                 arm64_sonoma:  "38ef101728df7bd59257cce89d43a941e531271b1fbed3689fd5af69bb05ac97"
    sha256 cellar: :any,                 arm64_ventura: "3248b999748438d68ac36a56bdb323f3189e4b5e08c56a5b43d47d705b9205aa"
    sha256 cellar: :any,                 sonoma:        "4a3c9a2360a592502413719b07c297802b3d2e7b210e4409c066fb03423d4eb0"
    sha256 cellar: :any,                 ventura:       "657bb3ec6a8a6af167b94e3d07ec5c4dd81ce3641475d7dcf853b3586f18c08a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8f80a059505a53588ed5a7abe98135a23cb30535b444bd4bf0b28e504ae6453"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57b2c80f352cc9e1d88b5f1e643e1c2e67436e1259a0353bac11ffca103e7af9"
  end

  depends_on "berkeley-db@5" # keep berkeley-db < 6 to avoid AGPL incompatibility
  depends_on "libevent"

  def install
    ENV.append "CFLAGS", "-std=gnu89"
    system "./configure", "--enable-threads", *std_configure_args
    system "make", "install"
  end

  test do
    port = free_port
    pid = spawn(bin/"memcacheq", "-p", port.to_s, "-H", testpath)
    sleep 5
    TCPSocket.open("localhost", port) do |sock|
      sock.puts("set brew 2 0 3\r\n100\r\n")
      assert_equal "STORED\r\n", sock.gets
      sock.puts("stats queue\r\n")
      assert_equal "STAT brew 1/0\r\n", sock.gets
    ensure
      sock.close
    end
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end
