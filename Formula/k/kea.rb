class Kea < Formula
  desc "DHCP server"
  homepage "https://www.isc.org/kea/"
  url "https://ftp.isc.org/isc/kea/3.0.1/kea-3.0.1.tar.xz"
  mirror "https://dl.cloudsmith.io/public/isc/kea-3-0/raw/versions/3.0.1/kea-3.0.1.tar.xz"
  sha256 "ec84fec4bb7f6b9d15a82e755a571e9348eb4d6fbc62bb3f6f1296cd7a24c566"
  license "MPL-2.0"
  head "https://gitlab.isc.org/isc-projects/kea.git", branch: "master"

  # NOTE: the livecheck block is a best guess at excluding development versions.
  #       Check https://www.isc.org/download/#Kea to make sure we're using a stable version.

  livecheck do
    url "ftp://ftp.isc.org/isc/kea/"
    # Match the final component lazily to avoid matching versions like `1.9.10` as `9.10`.
    regex(/v?(\d+\.\d*[02468](?:\.\d+)+?)$/i)
    strategy :page_match
  end

  bottle do
    sha256 arm64_tahoe:   "27111e61fb34f56bda0d838b35ff76584ae1107f86c418d4ac5e6d2dd19d741e"
    sha256 arm64_sequoia: "a0a5b7453df2b1268d9a169fd4038eaeec0b1927a33666d55007a11814ce3f5c"
    sha256 arm64_sonoma:  "51deee455cf31915852f855c6d9b693b05e3448a01abe36435eba8ee48797c4e"
    sha256 arm64_ventura: "3a3f166dfc98ee179e54f5ff4c844e7bd59435a93c9d11771fb98700a702afeb"
    sha256 sonoma:        "c403d0f93390d854fac900001d242d4e4fc6e9d451390cbd2e7bc54ce6acdb90"
    sha256 ventura:       "1c9c7c3f3d2425e84fc6c917aa9b84ae86f6210c92161278391ba4d18aabbd3f"
    sha256 arm64_linux:   "16e8c3806ebf07dd4fd910211e5fc29abe2c46f4d75240be2cd03fd03dfaf30c"
    sha256 x86_64_linux:  "e479046d56e9d10f7e90843b7337c6318b5c7c8bf1dd17815c65845fe9e94c36"
  end

  depends_on "bison" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build
  depends_on "boost"
  depends_on "log4cplus"
  depends_on "openssl@3"

  # Workaround for boost >= 1.89
  # https://gitlab.isc.org/isc-projects/kea/-/issues/4085
  patch :DATA

  def install
    # TODO: We probably also need to `inreplace` the following so they don't install in the prefix:
    #   - LOCALSTATEDIR_INSTALLED
    #   - RUNSTATEDIR_INSTALLED
    #   - SYSCONFDIR_INSTALLED
    # Report this upstream so they're not forced to be inside the `prefix`.
    inreplace "meson.build" do |s|
      # the build system looks for `sudo` to run some commands, but we don't want to use it
      s.gsub! "SUDO = find_program('sudo', required: false)",
              "SUDO = find_program('', required: false)"
    end

    system "meson", "setup", "build", "-Dcpp_std=c++20", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    # Remove the meson-info directory as it contains shim references
    rm_r(pkgshare/"meson-info")
  end

  test do
    system sbin/"keactrl", "status"
  end
end

__END__
diff --git a/meson.build b/meson.build
index cedc949773..aed020ebb2 100644
--- a/meson.build
+++ b/meson.build
@@ -189,7 +189,10 @@ message(f'Detected system "@SYSTEM@".')
 
 #### Dependencies
 
-boost_dep = dependency('boost', version: '>=1.66', modules: ['system'])
+boost_dep = dependency('boost', version: '>=1.69', required: false)
+if not boost_dep.found()
+    boost_dep = dependency('boost', version: '>=1.66', modules: ['system'])
+endif
 dl_dep = dependency('dl')
 threads_dep = dependency('threads')
 add_project_dependencies(boost_dep, dl_dep, threads_dep, language: ['cpp'])
diff --git a/src/lib/asiolink/asio_wrapper.h b/src/lib/asiolink/asio_wrapper.h
index a33c56f2d4..e1ae6e06f6 100644
--- a/src/lib/asiolink/asio_wrapper.h
+++ b/src/lib/asiolink/asio_wrapper.h
@@ -74,9 +74,11 @@
 #pragma GCC push_options
 #pragma GCC optimize ("O0")
 #include <boost/asio.hpp>
+#include <boost/asio/deadline_timer.hpp>
 #pragma GCC pop_options
 #else
 #include <boost/asio.hpp>
+#include <boost/asio/deadline_timer.hpp>
 #endif
 
 #endif // ASIO_WRAPPER_H
