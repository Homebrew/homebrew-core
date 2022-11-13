class BareosClient < Formula
  desc "Client for Bareos (Backup Archiving REcovery Open Sourced)"
  homepage "https://www.bareos.org/"
  url "https://github.com/bareos/bareos/archive/Release/21.1.5.tar.gz"
  sha256 "2bdae1c7b0667e49b62cea236c96c108a5b663b379170ab273a96f07494b01f0"
  license "AGPL-3.0-only"

  livecheck do
    url :stable
    regex(%r{^Release/(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_ventura:  "cfccea0a57967101dec78639c591503ed2abee5ecc900f162662e2a14d65681c"
    sha256 cellar: :any, arm64_monterey: "d639fb82e6cd35888ab8c724a408e73e999bcfa9bfe32c0b9fee9610b0caf454"
    sha256 cellar: :any, arm64_big_sur:  "2a5a9adbf88f24f8838e9fce8d91a239ed615453502645425c45865d812b2bb2"
    sha256 cellar: :any, monterey:       "6d80c269e60f2bb757c13152ac939a581d5b74fee348683eb725cb5477d7b36c"
    sha256 cellar: :any, big_sur:        "0328333023d9d5d591df4c1b499bec996e24eb33704c17bbf0f8765db88b2244"
    sha256 cellar: :any, catalina:       "df61dc4ca552da5208fd3bc3257f7d93e3b90fce8b2601c973bbbfe0eeb4e69d"
    sha256               x86_64_linux:   "2fe577a43e24359b30dd12ad4db3f9fe53241823ef334f49502b3ee7d39d086e"
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
    # Work around Linux build failure by disabling warning:
    # lmdb/mdb.c:2282:13: error: variable 'rc' set but not used [-Werror=unused-but-set-variable]
    # TODO: Try to remove in the next release which has various compiler warning changes
    ENV.append_to_cflags "-Wno-unused-but-set-variable" if OS.linux?

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

  plist_options startup: true
  service do
    run [opt_sbin/"bareos-fd", "-f"]
    log_path var/"run/bareos-fd.log"
    error_log_path var/"run/bareos-fd.log"
  end

  test do
    # Check if bareos-fd starts at all.
    assert_match version.to_s, shell_output("#{sbin}/bareos-fd -? 2>&1", 1)
    # Check if the configuration is valid.
    system sbin/"bareos-fd", "-t"
  end
end
