class BareosClient < Formula
  desc "Client for Bareos (Backup Archiving REcovery Open Sourced)"
  homepage "https://www.bareos.org/"
  url "https://github.com/bareos/bareos/archive/Release/19.2.9.tar.gz"
  sha256 "ea203d4bdacc8dcc86164a74f628888ce31cc90858398498137bd25900b8f723"
  license "AGPL-3.0-only"

  livecheck do
    url "https://github.com/bareos/bareos.git"
    regex(%r{^Release/(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 big_sur:  "bff8a75230cdc455bacd679e173d373d7ff11f10c57ed54ede298b7e7cb96816"
    sha256 catalina: "40e1558c583639b7788c4a5fb30a984abaa00a3a552f00b30466ac0bf8ce4e73"
    sha256 mojave:   "c1f6aa579b9a1923592818b041a165bc029d66bc88745895f6662ce2a3c83f8e"
  end

  depends_on "cmake" => :build
  depends_on "gettext"
  depends_on "openssl@1.1"
  depends_on "readline"

  conflicts_with "bacula-fd",
    because: "both install a `bconsole` executable"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
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
      system "make"
      system "make", "install"
    end
  end

  def post_install
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
