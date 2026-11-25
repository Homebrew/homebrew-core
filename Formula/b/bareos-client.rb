class BareosClient < Formula
  desc "Client for Bareos (Backup Archiving REcovery Open Sourced)"
  homepage "https://www.bareos.com/"
  # TODO: Switch to openssl@4 in 26.0.0 - https://github.com/bareos/bareos/milestone/16
  url "https://github.com/bareos/bareos/archive/refs/tags/Release/25.1.3.tar.gz"
  sha256 "6f95a7a1347d1dc3b33102cf6e6abf86b93398ada58164c72aea2b2559b2adc0"
  license "AGPL-3.0-only"

  livecheck do
    url :stable
    regex(%r{^Release/(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    manifest_sha256 "33a4b7a33ca3b1eeb3ea959cab0e2b0a5ac7b0ab366edbe6c5d683d39c2cb747"
    sha256 arm64_golden_gate: "317e7a1d47c03ea334f01231bdc0227122f22fca46cd7c0d539bb183e3f36cfa"
    sha256 arm64_tahoe:       "bffebcd82da266159d91b67f84abbb78d9170151ff83ddf664c6b754d907cbd5"
    sha256 arm64_sequoia:     "10ce3ac9b9686cfb3eb3329ebec537e150c43b12f53bc6f293e257d043f97854"
    sha256 arm64_linux:       "edd5c64db8df69421f2011ebb296507624b6875ed810963dbfc3ba4383b7b0e9"
    sha256 x86_64_linux:      "723cfbbe8ac47c30b8b9634fa6f46a36bea3df521bd24759174d96f559d530b8"
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

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "acl"
    depends_on "zlib-ng-compat"
  end

  conflicts_with "bacula-fd", because: "both install a `bconsole` executable"

  deny_network_access!

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
    inreplace "core/cmake/BareosFindAllLibraries.cmake", "set(OPENSSL_USE_STATIC_LIBS 1)", ""

    inreplace "core/src/filed/CMakeLists.txt",
              "bareos-fd PROPERTIES INSTALL_RPATH \"@loader_path/../${libdir}\"",
              "bareos-fd PROPERTIES INSTALL_RPATH \"${libdir}\""

    # `cpp-gsl` is 5.x and GSL's config is SameMajorVersion, so CPM's 4.0.0 request would fetch instead
    inreplace "cmake/BareosCpmPackages.cmake",
              "  NAME Microsoft.GSL\n  VERSION \"4.0.0\"",
              "  NAME Microsoft.GSL\n  VERSION \"5.0.0\""

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DCPM_LOCAL_PACKAGES_ONLY=ON",
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

  post_install_steps do
    mkdir_p "lib/bareos", base: :var
    unless_path_exists "{{etc}}/bareos/bareos-fd.d" do
      run "bareos/scripts/bareos-config", args: ["deploy_config", "bareos-fd"], base: :lib
      run "bareos/scripts/bareos-config", args: ["deploy_config", "bconsole"], base: :lib
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
