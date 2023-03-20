class BareosClient < Formula
  desc "Client for Bareos (Backup Archiving REcovery Open Sourced)"
  homepage "https://www.bareos.org/"
  url "https://github.com/bareos/bareos/archive/Release/22.0.2.tar.gz"
  sha256 "70658b2ffb58599cd8f5eb0d700c07b112a618866c9d941f784c04be16924cfb"
  license "AGPL-3.0-only"

  livecheck do
    url :stable
    regex(%r{^Release/(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 arm64_ventura:  "11db9e64da397b206bb93979bc5680438c7771393c86c9186b265611ea4a96fb"
    sha256 arm64_monterey: "096213ed7d05ec2cbdfdbd0412158e616aa69c52d1379a5167f706f6363bd69b"
    sha256 arm64_big_sur:  "0d57ffd282865aa9cd28e482b1087a1eda508ac935736901ead4c3e7a2c83a52"
    sha256 ventura:        "e47bb2c79d69670f1989d5880e0881c08c89fadd193fbc61564ea74f579221a7"
    sha256 monterey:       "6aeb7c540d9411e9da68c1aa3a4df77def6bb09987ed26cda91a3a501304c006"
    sha256 big_sur:        "ad0251f4962266b14521af06cda449854094785f8074107ede6ccfc4cd9828eb"
    sha256 x86_64_linux:   "605dbfedf560f2523127837679768094e3065b59b6e68be74eca50617fcc7c26"
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
