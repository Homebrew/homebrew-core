class Et < Formula
  desc "Remote terminal with IP roaming"
  homepage "https://mistertea.github.io/EternalTerminal/"
  url "https://github.com/MisterTea/EternalTerminal/archive/refs/tags/et-v7.1.1.tar.gz"
  sha256 "7f5ab26f5cc18e66184d806648a2437c447b549ca106a7e6107f793435e39270"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "dc91389f42b64e0b88a0eb3c8dcd2d5c0c376d69e8d2cbcb964fda7263813ec4"
    sha256 cellar: :any, arm64_tahoe:       "381012be6ccc37c626b73cbfb06463e0f64ba99092627163c9afa64751fc2a93"
    sha256 cellar: :any, arm64_sequoia:     "428d43af63d8a75a9bf0726f70de8394c4261c868b41e89c2ddd3ec26e9f21d5"
    sha256 cellar: :any, arm64_linux:       "c80bab11c9d161d746c748506257bf8f81c8f8905a656b2f2bfc9fbae2fa28f2"
    sha256 cellar: :any, x86_64_linux:      "f0a406a9eaef5507f1690e9db57cd59576023724120743b90699ee0b1c3f3e83"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "abseil"
  depends_on "libsodium"
  depends_on "openssl@4"
  depends_on "protobuf"

  on_linux do
    depends_on "brotli"
    depends_on "zlib-ng-compat"
  end

  allow_network_access! :test

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

    # Remove Windows-specific script
    rm bin/"et1.cmd"

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
    # Avoid the default `$HOME/.local/share/etserver` fifo directory, whose
    # ancestor checks open `/` for reading and fail inside the Linux sandbox.
    pid = spawn bin/"etserver", "--port", port.to_s, "--serverfifo", testpath/"etserver.fifo", "--logtostdout"

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
