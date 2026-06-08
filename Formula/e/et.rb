class Et < Formula
  desc "Remote terminal with IP roaming"
  homepage "https://mistertea.github.io/EternalTerminal/"
  url "https://github.com/MisterTea/EternalTerminal/archive/refs/tags/et-v6.2.11.tar.gz"
  sha256 "e8e80800babc026be610d50d402a8ecbdfbd39e130d1cfeb51fb102c1ad63b0f"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f24772b0029f9afaf49228c803b30806a172f855039adfea1cdae81b99ff2c31"
    sha256 cellar: :any,                 arm64_sequoia: "bedd1da9c634807b28da0fcc3374a39823361372f6c460818a09cffa7c18ba07"
    sha256 cellar: :any,                 arm64_sonoma:  "895de284311361692fd09d16e81222cc6e7d2ad36b3d1d41798dc22a298c0e60"
    sha256 cellar: :any,                 sonoma:        "ef29493b51025930178b0b080be9cd1de0d17a3655ebd5e8ce2a7022baf8688a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7003beb617a854cde0e18a7b4482517300fb01476a44e6a99a06906f51216b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20d6cc89670d8bdd1c657c101fe7b582a6986d4e267e59bdd3eb160f3f3208a8"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "libsodium"
  depends_on "openssl@4"
  depends_on "protobuf"

  on_linux do
    depends_on "brotli"
    depends_on "zlib-ng-compat"
  end

  def install
    # https://github.com/protocolbuffers/protobuf/issues/9947
    ENV.append_to_cflags "-DNDEBUG"
    # Avoid over-linkage to `abseil`.
    ENV.append "LDFLAGS", "-Wl,-dead_strip_dylibs" if OS.mac?

    args = %W[
      -DDISABLE_VCPKG=ON
      -DDISABLE_SENTRY=ON
      -DDISABLE_TELEMETRY=ON
      -DBUILD_TESTING=OFF
      -DPYTHON_EXECUTABLE=#{which("python3")}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    etc.install "etc/et.cfg"
  end

  service do
    run [opt_bin/"etserver", "--cfgfile", etc/"et.cfg"]
    keep_alive false
    working_dir HOMEBREW_PREFIX
    error_log_path var/"log/et/etserver.err"
    log_path var/"log/et/etserver.log"
    require_root true
  end

  test do
    port = free_port
    pid = fork do
      exec bin/"etserver", "--port", port.to_s, "--logtostdout"
    end

    begin
      require "socket"
      Timeout.timeout(60) do
        loop do
          TCPSocket.open("127.0.0.1", port).close
          break
        rescue Errno::ECONNREFUSED
          sleep 1
        end
      end
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
