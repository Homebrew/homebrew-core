class Et < Formula
  desc "Remote terminal with IP roaming"
  homepage "https://mistertea.github.io/EternalTerminal/"
  url "https://github.com/MisterTea/EternalTerminal/archive/refs/tags/et-v6.2.11.tar.gz"
  sha256 "e8e80800babc026be610d50d402a8ecbdfbd39e130d1cfeb51fb102c1ad63b0f"
  license "Apache-2.0"
  revision 2

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8642272a3f0c459b82eb763846ea884df187d167cb9069e7258441692a85db56"
    sha256 cellar: :any, arm64_sequoia: "e289b93daeb45957123fd10cf34d633d3104c0231d07c0c7074afe3ca8a34f3f"
    sha256 cellar: :any, arm64_sonoma:  "2d5ae82aa5223c4702c8dafb32913c0b9fcd46fbbafa741021af613b49292ceb"
    sha256 cellar: :any, sonoma:        "7c9f341438cb716a01c02029afaeac7ae4d6323ad5d956835d6419884b18d3a9"
    sha256 cellar: :any, arm64_linux:   "5ae01e6d069f47dd8f0cc9b657d95fe1ae52ecd7c5d7ee2264d359d62f04ed82"
    sha256 cellar: :any, x86_64_linux:  "c23c81bb69330fcffda582bafabfc9aa96b00eb345da2ace8319b194f0461c61"
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
