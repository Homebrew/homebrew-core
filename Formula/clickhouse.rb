class Clickhouse < Formula
  desc "Free analytics DBMS for big data with SQL interface"
  homepage "https://clickhouse.com"
  url "https://github.com/ClickHouse/ClickHouse/releases/download/v21.11.1.8636-prestable/ClickHouse_sources_with_submodules.tar.gz"
  sha256 "e95576f1b9f557ae7aa808fbe8959f14fbc86981d809d21e49eb65fe4ebf1142"
  license "Apache-2.0"
  head "https://github.com/ClickHouse/ClickHouse.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "gawk" => :build
  depends_on "gettext" => :build
  depends_on "libtool" => :build
  depends_on "ninja" => :build
  depends_on "perl" => :build
  depends_on "python@3.9" => :build
  depends_on "llvm" => "13"

  def install
    cmake_args = std_cmake_args.dup

    # It is crucial that CMake config scripts see RelWithDebInfo as a build type,
    # since the code is only handling it (and Debug) properly.
    # It is OK if Homebrew infrastructure filters out the debug info-related flags later.
    cmake_args.reject! { |x| x.start_with?("-DCMAKE_BUILD_TYPE=") }
    cmake_args << "-DCMAKE_BUILD_TYPE=RelWithDebInfo"

    # Vanilla Clang is the only officially supported compiler.
    cmake_args << "-DCMAKE_C_COMPILER=#{Formula["llvm"].bin}/clang"
    cmake_args << "-DCMAKE_CXX_COMPILER=#{Formula["llvm"].bin}/clang++"
    cmake_args << "-DCMAKE_AR=#{Formula["llvm"].bin}/llvm-ar"
    cmake_args << "-DCMAKE_RANLIB=#{Formula["llvm"].bin}/llvm-ranlib"
    cmake_args << "-DOBJCOPY_PATH=#{Formula["llvm"].bin}/llvm-objcopy"

    # Disable more stuff that is irrelevant for production builds.
    cmake_args << "-DENABLE_CCACHE=OFF"
    cmake_args << "-DSANITIZE=OFF"
    cmake_args << "-DENABLE_TESTS=OFF"
    cmake_args << "-DENABLE_CLICKHOUSE_TEST=OFF"

    system "cmake", "-S", ".", "-B", "./build", "-G", "Ninja", *cmake_args
    system "cmake", "--build", "./build", "--config", "RelWithDebInfo", "--target", "clickhouse", "--parallel"

    system "./build/programs/clickhouse", "install", "--prefix", HOMEBREW_PREFIX, "--binary-path", prefix/"bin"
  end

  def post_install
    # Make sure the data directories are initialized.
    system opt_bin/"clickhouse", "start", "--prefix", HOMEBREW_PREFIX, "--binary-path", opt_bin
    system opt_bin/"clickhouse", "stop", "--prefix", HOMEBREW_PREFIX
  end

  def caveats
    <<~EOS
      If you intend to run ClickHouse server:

        - Familiarize yourself with the usage recommendations:
            https://clickhouse.com/docs/en/operations/tips/

        - Increase the maximum number of open files limit in the system:
            Linux: man limits.conf
            macOS: https://clickhouse.com/docs/en/development/build-osx/#caveats

        - By default, the pre-configured 'default' user has an empty password. Consider setting a real password for it:
            https://clickhouse.com/docs/en/operations/settings/settings-users/

        - By default, ClickHouse server is configured to listen for local connections only. Adjust 'listen_host' configuration parameter to allow wider range of addresses for incoming connections:
            https://clickhouse.com/docs/en/operations/server-configuration-parameters/settings/#server_configuration_parameters-listen_host
    EOS
  end

  service do
    run [
      opt_bin/"clickhouse", "server",
      "--config-file", etc/"clickhouse-server/config.xml",
      "--pid-file", var/"run/clickhouse-server/clickhouse-server.pid"
    ]
    keep_alive true
    run_type :immediate
    working_dir var
    log_path var/"log/clickhouse-server/stdout.log"
    error_log_path var/"log/clickhouse-server/stderr.log"
  end

  test do
    assert_match "Denis Glazachev",
      shell_output("#{bin}/clickhouse local --query 'SELECT * FROM system.contributors FORMAT TabSeparated'")
  end
end
