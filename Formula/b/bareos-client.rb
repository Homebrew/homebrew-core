class BareosClient < Formula
  desc "Client for Bareos (Backup Archiving REcovery Open Sourced)"
  homepage "https://www.bareos.org/"
  url "https://github.com/bareos/bareos/archive/refs/tags/Release/23.0.4.tar.gz"
  sha256 "55fc4d2de3f4a5ca9d728da98acf348a9f6a0c29c719d526029bff50f65d2c55"
  license "AGPL-3.0-only"

  livecheck do
    url :stable
    regex(%r{^Release/(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 arm64_sequoia:  "14f1f91ca6e2ddc36d1e967850b06a6af6acbd6d706fb0fb6852eb18c48382b1"
    sha256 arm64_sonoma:   "e7260d9b636ea8b344f824533cd1cc38e4ec5b69b36de9aa1a41283233fafe5a"
    sha256 arm64_ventura:  "bf51da611653906758bd92f978ba8ca5dd8e74a9c730e7b1888fb71ef2392a19"
    sha256 arm64_monterey: "9cc06db6fb7ca760ba16bf89d1ee71f94f86487132bf8cab3a9723b76db1d368"
    sha256 sonoma:         "c0241c91796e79d616c1fbd486078beb77575515aaf1c9de34ffebdf2921540d"
    sha256 ventura:        "a6db2e0b30c312785c1d173fc53bf8d597e6c244b5b496fc9df0faa82d38ba83"
    sha256 monterey:       "a86fc0dc354205902e11a967ca70ad124a6d14455662cee9a5b4f33ac4cee686"
    sha256 x86_64_linux:   "0972bd1a75de56ee7605f0ad5a7af94e57c4de2d83ec371f9ddf345a71414e91"
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

    # Work around hardcoded paths forced static linkage on macOS
    inreplace "core/cmake/BareosFindAllLibraries.cmake" do |s|
      s.gsub! "set(OPENSSL_USE_STATIC_LIBS 1)", ""
      s.gsub! "${HOMEBREW_PREFIX}/opt/lzo/lib/liblzo2.a", Formula["lzo"].opt_lib/shared_library("liblzo2")
    end

    inreplace "core/cmake/FindReadline.cmake",
              "${HOMEBREW_PREFIX}/opt/readline/lib/libreadline.a",
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
                    "-Dclient-only=ON",
                    "-DENABLE_LZO=ON"
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
