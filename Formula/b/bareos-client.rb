class BareosClient < Formula
  desc "Client for Bareos (Backup Archiving REcovery Open Sourced)"
  homepage "https://www.bareos.com/"
  url "https://github.com/bareos/bareos/archive/refs/tags/Release/24.0.5.tar.gz"
  sha256 "52bbd9cde1c8a2e7fe7c00fb41215e5add112607de7a2ca77677a28752e7a8d7"
  license "AGPL-3.0-only"

  livecheck do
    url :stable
    regex(%r{^Release/(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 arm64_tahoe:   "23b418203c51a27f672757a88d6e14f6c38a1a9c32996b6f638e36279b3d4433"
    sha256 arm64_sequoia: "8cc7292958805069c8cc8512e107a1b32c36ed863c65e3636a4a7939577e9ffd"
    sha256 arm64_sonoma:  "af07193d70b09c51e5654433632912b272b6166b2d79e280a8933832f3cd0bd8"
    sha256 arm64_ventura: "9a0a6c40b66a9249046e538afaca227b46f58508bd9c3202e87db8fd7260f8f5"
    sha256 sonoma:        "7423d9063d1a18bf19e08e2bd550868b5f977a54c600ae688f2f8bffed53a9b1"
    sha256 ventura:       "4da2935b800f6439d7751b88252fb275eb7841628b33cf2bead5f5657c09395a"
    sha256 arm64_linux:   "b78766c14fd2026780808de2770804734e1183041fcd0c4e39d390e434bc9764"
    sha256 x86_64_linux:  "f919f6c532f9e47473105e20c1705a0c2126e5b7bcf395d654ee3305da764fad"
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
