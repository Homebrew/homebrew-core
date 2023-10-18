class BareosClient < Formula
  desc "Client for Bareos (Backup Archiving REcovery Open Sourced)"
  homepage "https://www.bareos.org/"
  url "https://github.com/bareos/bareos/archive/Release/22.1.0.tar.gz"
  sha256 "f1ee802751cdf89c46d1817e08a7caa937d02c6615940666c420cf17601b8b9c"
  license "AGPL-3.0-only"

  livecheck do
    url :stable
    regex(%r{^Release/(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 arm64_sonoma:   "c85663b87c2069674f74daa467b427dbb0adde00ecdd23d2d5da70ce5849bc0b"
    sha256 arm64_ventura:  "e86d1ce16bc66fdf6dfe1970900f30caa047ae168010314e361c4f381992b6d0"
    sha256 arm64_monterey: "41c162660184898882572268b91b7c5d7e1e4c212fae191dff57a742d1ac153d"
    sha256 arm64_big_sur:  "844bdbffec650e13937bfe75d5320d82785f3934524fcc8467c11362814507e4"
    sha256 sonoma:         "cafc0eedc3067e6f86d31fd7dcc555625802b3cf00422501e458973b3c778b5f"
    sha256 ventura:        "14881605ad0493cd05cfaa77c1737290e6fbeb1771810d4b0694e64a8f92a202"
    sha256 monterey:       "9e27718126d33afedb0b01634011c4a9edffcc2cb648f409699aa6484a688ffd"
    sha256 big_sur:        "69c7bc9ce269bd759fdfb1846187e1e594b9e4652c621cc5fb99c49edb5ededf"
    sha256 x86_64_linux:   "fcaf2fafe2c5e2fe23adf648ccf5c22c2a1b211c6addbd3ab6b87e2af2575676"
  end

  depends_on "cmake" => :build
  depends_on "jansson"
  depends_on "lzo"
  depends_on "openssl@3"
  depends_on "readline"

  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "acl"
  end

  conflicts_with "bacula-fd", because: "both install a `bconsole` executable"

  def install
    # Work around Linux build failure by disabling warnings:
    # lmdb/mdb.c:2282:13: error: variable 'rc' set but not used [-Werror=unused-but-set-variable]
    # fastlzlib.c:512:63: error: unused parameter ‘output_length’ [-Werror=unused-parameter]
    # Upstream issue: https://bugs.bareos.org/view.php?id=1504
    if OS.linux?
      ENV.append_to_cflags "-Wno-unused-but-set-variable"
      ENV.append_to_cflags "-Wno-unused-parameter"
    end

    # Work around hardcoded paths to /usr/local Homebrew installation,
    # forced static linkage on macOS, and openssl formula alias usage.
    inreplace "core/CMakeLists.txt" do |s|
      s.gsub! "/usr/local/opt/gettext/lib/libintl.a", Formula["gettext"].opt_lib/shared_library("libintl")
      s.gsub! "/usr/local/opt/openssl", Formula["openssl@3"].opt_prefix
      s.gsub! "/usr/local/", "#{HOMEBREW_PREFIX}/"
    end
    inreplace "core/src/plugins/CMakeLists.txt" do |s|
      s.gsub! "/usr/local/opt/gettext/include", Formula["gettext"].opt_include
      s.gsub! "/usr/local/opt/openssl/include", Formula["openssl@3"].opt_include
    end
    inreplace "core/cmake/BareosFindAllLibraries.cmake" do |s|
      s.gsub! "/usr/local/opt/lzo/lib/liblzo2.a", Formula["lzo"].opt_lib/shared_library("liblzo2")
      s.gsub! "set(OPENSSL_USE_STATIC_LIBS 1)", ""
    end
    inreplace "core/cmake/FindReadline.cmake",
              "/usr/local/opt/readline/lib/libreadline.a",
              Formula["readline"].opt_lib/shared_library("libreadline")

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DENABLE_PYTHON=OFF",
                    "-Dworkingdir=#{var}/lib/bareos",
                    "-Darchivedir=#{var}/bareos",
                    "-Dconfdir=#{etc}/bareos",
                    "-Dconfigtemplatedir=#{lib}/bareos/defaultconfigs",
                    "-Dscriptdir=#{lib}/bareos/scripts",
                    "-Dplugindir=#{lib}/bareos/plugins",
                    "-Dfd-password=XXX_REPLACE_WITH_CLIENT_PASSWORD_XXX",
                    "-Dmon-fd-password=XXX_REPLACE_WITH_CLIENT_MONITOR_PASSWORD_XXX",
                    "-Dbasename=XXX_REPLACE_WITH_LOCAL_HOSTNAME_XXX",
                    "-Dhostname=XXX_REPLACE_WITH_LOCAL_HOSTNAME_XXX",
                    "-Dclient-only=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def post_install
    (var/"lib/bareos").mkpath
    # If no configuration files are present,
    # deploy them (copy them and replace variables).
    unless (etc/"bareos/bareos-fd.d").exist?
      system lib/"bareos/scripts/bareos-config", "deploy_config",
             lib/"bareos/defaultconfigs", etc/"bareos", "bareos-fd"
      system lib/"bareos/scripts/bareos-config", "deploy_config",
             lib/"bareos/defaultconfigs", etc/"bareos", "bconsole"
    end
  end

  service do
    run [opt_sbin/"bareos-fd", "-f"]
    require_root true
    log_path var/"run/bareos-fd.log"
    error_log_path var/"run/bareos-fd.log"
  end

  test do
    # Check if bareos-fd starts at all.
    assert_match version.to_s, shell_output("#{sbin}/bareos-fd -? 2>&1")
    # Check if the configuration is valid.
    system sbin/"bareos-fd", "-t"
  end
end
