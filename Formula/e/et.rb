class Et < Formula
  desc "Remote terminal with IP roaming"
  homepage "https://mistertea.github.io/EternalTerminal/"
  url "https://github.com/MisterTea/EternalTerminal/archive/refs/tags/et-v6.2.11.tar.gz"
  sha256 "e8e80800babc026be610d50d402a8ecbdfbd39e130d1cfeb51fb102c1ad63b0f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c14ad953bcc4571ce51e889d15557bad0a15ddb203d8b73bf0ccac823f5f1405"
    sha256 cellar: :any,                 arm64_sequoia: "161e483009fa29de8ef1db8e0fd6d3a7d63e97d0814e170a702daf224590af12"
    sha256 cellar: :any,                 arm64_sonoma:  "4e223a932b062e0eac5f6147def2b4cac109b23f772d96b381ba34706b623fe4"
    sha256 cellar: :any,                 sonoma:        "acdda6aa6132c0e9652c901c806acd5f3d2a05b71a1f73c8ab182b8dea643dc2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "776af490681d4b07a0ab51a5dd3bd1164b7db1d7064d0195c36d8ebcb3ba76df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0cc0303a8c6dd42fddfc899880ee2f60d3264817837a628bcd2e6595005f8e3b"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "libsodium"
  depends_on "openssl@3"
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
