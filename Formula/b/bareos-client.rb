class BareosClient < Formula
  desc "Client for Bareos (Backup Archiving REcovery Open Sourced)"
  homepage "https://www.bareos.com/"
  url "https://github.com/bareos/bareos/archive/refs/tags/Release/25.1.0.tar.gz"
  sha256 "3e39bcdb17e1f4b51c7702b1bf6e55a9fae350cee52ede604d4c63f2ba0f4621"
  license "AGPL-3.0-only"

  livecheck do
    url :stable
    regex(%r{^Release/(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 arm64_tahoe:   "a503f0385b4a78789f11cee650abeb9cf29078340570bb01c8e4be0a546d0cf0"
    sha256 arm64_sequoia: "d97c09b75db36e6517b0b8cb9761b9b5687096a0eac2dd37c21285f902a46fe0"
    sha256 arm64_sonoma:  "79aa39d5e839e56d34dc7a12a01587da683157a1196b7d12bff164553f27e265"
    sha256 sonoma:        "91a3242d1c3952645bce8f5340e3327a8255230ea44bb6d6e6baa8cd6b6394f6"
    sha256 arm64_linux:   "634a7d06028f6cbb43339491c108189f053b412a4a8897eb28f59c0f991a55d5"
    sha256 x86_64_linux:  "60767ca6d60dce4580518cff04737f297aecdb8fce146a8271f554d2b74490d6"
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
