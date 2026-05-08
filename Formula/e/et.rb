class Et < Formula
  desc "Remote terminal with IP roaming"
  homepage "https://mistertea.github.io/EternalTerminal/"
  url "https://github.com/MisterTea/EternalTerminal/archive/refs/tags/et-v6.2.11.tar.gz"
  sha256 "e8e80800babc026be610d50d402a8ecbdfbd39e130d1cfeb51fb102c1ad63b0f"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "d6a34468a1f8717d8e5883df897360f447be2da8d39b6c19c9340a723247f953"
    sha256 cellar: :any,                 arm64_sequoia: "84069668e2b37c83feb09b520b3446555b8cb2e5e5d98d70b85e305cdaf0fcbd"
    sha256 cellar: :any,                 arm64_sonoma:  "50fd905b77f11c9da8a9583fd907625619bacdefcd6790273d1c6c34f929f509"
    sha256 cellar: :any,                 sonoma:        "b43d881f5a6b9f44137fead22d6d33d5ac9ef360267e14a96a6f64172bc2657f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3eeea0b83e230c75aaac71fa63d3c4eeb644973a5edf6d82161cc89844bb304c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55ccaf1da1a2aebe6cd71dfecdf19144fe0203df1f49900242d145d3a0ab4401"
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
