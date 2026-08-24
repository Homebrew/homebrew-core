class Et < Formula
  desc "Remote terminal with IP roaming"
  homepage "https://mistertea.github.io/EternalTerminal/"
  url "https://github.com/MisterTea/EternalTerminal/archive/refs/tags/et-v7.0.0.tar.gz"
  sha256 "3580962861589c0b69efd6b385ff92ad8fdf688c91d1a0edc1a83278205e28e8"
  license "Apache-2.0"
  revision 3

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2d09eab725877a3e0929ac4817d6392a958424d443213f2baa5c4b700b913150"
    sha256 cellar: :any, arm64_sequoia: "7250e925e8f575874372cbfdb6db89bc3f5847b157877f604277968ef3aa3b29"
    sha256 cellar: :any, arm64_sonoma:  "0bdab5ce9fc140e87f0fc21a14b20a5e1beed1bca551b8a70d4385ebd783f9b4"
    sha256 cellar: :any, sonoma:        "bff403b961ca8be370466d65758419e6bb1e850cc25bc5fc46455f08504a9cdd"
    sha256 cellar: :any, arm64_linux:   "1babcb2dd55de9af52fa277517e4f8123b7d09188a5677eb3bd3b891627dc7b6"
    sha256 cellar: :any, x86_64_linux:  "2c2a4366f16212b638b128cafc84b96e1ac4c3270773bd697ad26a67fb426558"
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
