class Et < Formula
  desc "Remote terminal with IP roaming"
  homepage "https://mistertea.github.io/EternalTerminal/"
  url "https://github.com/MisterTea/EternalTerminal/archive/refs/tags/et-v7.0.0.tar.gz"
  sha256 "3580962861589c0b69efd6b385ff92ad8fdf688c91d1a0edc1a83278205e28e8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a94790a5c5e507fce2268997d7f13cbfd814ad88eff95b1956be3a453a841251"
    sha256 cellar: :any, arm64_sequoia: "95645c2060eb7b56547f7d3faeae108734e8660e457612ce260320bd63a4e929"
    sha256 cellar: :any, arm64_sonoma:  "3d67d563ff7bc069f2fdf0306c792781ff35740945669efae9c0d6d6c8716ef5"
    sha256 cellar: :any, sonoma:        "c582a6ae12e2fbe97d6c65308e7cc4c8a9e488531c04a353cb38da1d5dfcc2df"
    sha256 cellar: :any, arm64_linux:   "77f97ff040c539a7e6ed3121d70c44facc32b0bfe6dcd5a1866fe37335a90493"
    sha256 cellar: :any, x86_64_linux:  "4b29f1994351c4b3fee25a646fa7d6bae9f68f8ad32648af65e3c53891a1f1d7"
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
