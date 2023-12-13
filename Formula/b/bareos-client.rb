class BareosClient < Formula
  desc "Client for Bareos (Backup Archiving REcovery Open Sourced)"
  homepage "https://www.bareos.org/"
  url "https://github.com/bareos/bareos/archive/refs/tags/Release/22.1.3.tar.gz"
  sha256 "765bf250a34296756051e896b28130b2ca3965cebaf310116c50e3e6c63d7d52"
  license "AGPL-3.0-only"

  livecheck do
    url :stable
    regex(%r{^Release/(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 arm64_sonoma:   "b5b2762373a85ac689bba63de424b99ef30526f4f4bb0558cc725c023074352c"
    sha256 arm64_ventura:  "2011794e7ccea015f660674a621a6416ad12a5cfd5c30ef1d159669f7a171906"
    sha256 arm64_monterey: "94bf68422aeda9711b6f16b380e8445a2c0836bdb2de7b66ca8e06afce0a04d0"
    sha256 sonoma:         "d3731e41a2302c9afa1054d5cd5cadadb41b3f3a495c831cebafabc04f8e87a3"
    sha256 ventura:        "35e0b7326be9baacee241e9e3c49e4f1b831e471636e6b2a0aa80aed903d78e5"
    sha256 monterey:       "d1af934532bd85428bce5defee28f38ddc39d4bc191b5fcea36ac3061b5fa7d0"
    sha256 x86_64_linux:   "546524a5d9849ce0c63f1993f973893906a88550df32727a6779c012d7f216dd"
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
