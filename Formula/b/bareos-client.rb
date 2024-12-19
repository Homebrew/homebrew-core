class BareosClient < Formula
  desc "Client for Bareos (Backup Archiving REcovery Open Sourced)"
  homepage "https://www.bareos.com/"
  url "https://github.com/bareos/bareos/archive/refs/tags/Release/24.0.0.tar.gz"
  sha256 "3cfc7e4b13143a9c39173d9e970476c3ba322761504513458552248700b8162d"
  license "AGPL-3.0-only"

  livecheck do
    url :stable
    regex(%r{^Release/(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 arm64_sequoia: "2ad752307a647086463caa7c0c66392a19963b963e76c6278a4303581ea82ee3"
    sha256 arm64_sonoma:  "cf629a37f5340eb00e82b38136c78d59a86353f8a0ca013645a3f331563d581b"
    sha256 arm64_ventura: "945c8b7a8c7a61b923eaad54f22cf9e3106d7b7e9a18049626e559511a2deaeb"
    sha256 sonoma:        "95fab9a2bdfc872b0bc5ffec51149d57aa7151a9f868216f646d4a4e443be511"
    sha256 ventura:       "5e7eb17048a2087046dc9c4bfbee31bd463a88098d5fd7fae8186815e38469a5"
    sha256 x86_64_linux:  "d7ac818be759920e3a5fe1f97a167245fb5e2f5399ee7ddd3ad639a776449385"
  end

  depends_on "cli11" => :build
  depends_on "cmake" => :build
  depends_on "cpp-gsl" => :build
  depends_on "fmt" => :build
  depends_on "tl-expected" => :build
  depends_on "utf8cpp" => :build
  depends_on "jansson"
  depends_on "lzo"
  depends_on "openssl@3"
  depends_on "readline"
  depends_on "xxhash"

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

    # Work around hardcoded paths forced static linkage on macOS
    inreplace "core/cmake/BareosFindAllLibraries.cmake" do |s|
      s.gsub! "set(OPENSSL_USE_STATIC_LIBS 1)", ""
      s.gsub! "${HOMEBREW_PREFIX}/opt/lzo/lib/liblzo2.a", Formula["lzo"].opt_lib/shared_library("liblzo2")
    end
    inreplace "core/CMakeLists.txt" do |s|
      s.gsub! "${HOMEBREW_PREFIX}/opt/gettext/lib/libintl.a", Formula["gettext"].opt_lib/shared_library("libintl")
      s.gsub! "iconv", "-liconv"
    end

    inreplace "core/cmake/FindReadline.cmake",
              "${HOMEBREW_PREFIX}/opt/readline/lib/libreadline.a",
              Formula["readline"].opt_lib/shared_library("libreadline")

    args = %W[
      -DENABLE_PYTHON=OFF
      -Dworkingdir=#{var}/lib/bareos
      -Darchivedir=#{var}/bareos
      -Dconfdir=#{etc}/bareos
      -Dconfigtemplatedir=#{lib}/bareos/defaultconfigs
      -Dscriptdir=#{lib}/bareos/scripts
      -Dplugindir=#{lib}/bareos/plugins
      -Dfd-password=XXX_REPLACE_WITH_CLIENT_PASSWORD_XXX
      -Dmon-fd-password=XXX_REPLACE_WITH_CLIENT_MONITOR_PASSWORD_XXX
      -Dbasename=XXX_REPLACE_WITH_LOCAL_HOSTNAME_XXX
      -Dhostname=XXX_REPLACE_WITH_LOCAL_HOSTNAME_XXX
      -Dclient-only=ON
      -DENABLE_LZO=ON
      -DFETCHCONTENT_FULLY_DISCONNECTED=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
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
