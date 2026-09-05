class BareosClient < Formula
  desc "Client for Bareos (Backup Archiving REcovery Open Sourced)"
  homepage "https://www.bareos.com/"
  url "https://github.com/bareos/bareos/archive/refs/tags/Release/25.1.1.tar.gz"
  sha256 "158aba5941fcd1921292d2fe283bce1fe9122b5c81106267cb352678f76af83b"
  license "AGPL-3.0-only"

  livecheck do
    url :stable
    regex(%r{^Release/(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 arm64_tahoe:   "0ba3b439d35d6f31e17bd023a05037add87ecd314a455f4285dde9c16c0b37b1"
    sha256 arm64_sequoia: "0fd15bd4147f8bb27618ce68277ef184e9e5b123158114bd2a5104eb4340b404"
    sha256 arm64_sonoma:  "54018b0d88edbf6057b1920a8a854c1932edfe72c234473f598468ccac20a654"
    sha256 arm64_linux:   "6e42ac0b846ed8cc4d7232ed9c73ff25d4fa2229c9892663a3bdb5f6c8c89fe0"
    sha256 x86_64_linux:  "a82a3525625a5f90822d40fb8a7ed7cd3cb4503034ef47694252dbdc26dc3e73"
  end

  depends_on "cli11" => :build
  depends_on "cmake" => :build
  depends_on "cpp-gsl" => :build
  depends_on "fmt" => :build
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
