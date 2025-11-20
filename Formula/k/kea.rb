class Kea < Formula
  desc "DHCP server"
  homepage "https://www.isc.org/kea/"
  url "https://ftp.isc.org/isc/kea/3.0.2/kea-3.0.2.tar.xz"
  mirror "https://dl.cloudsmith.io/public/isc/kea-3-0/raw/versions/3.0.2/kea-3.0.2.tar.xz"
  sha256 "29f4e44fa48f62fe15158d17411e003496203250db7b3459c2c79c09f379a541"
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
    sha256 arm64_tahoe:   "ea50b361b103099e1706a14a54167b404eb4b0d3dbb3d0fa50e54174ef98efe0"
    sha256 arm64_sequoia: "e6ff6481bc98b840e2f35bc835d705aab1f74a99e5cf2afa238d59867558a641"
    sha256 arm64_sonoma:  "38616d8745ecb5f676ad16829efe60ea4781ea57cd981ad221b3da0e570ad5a4"
    sha256 sonoma:        "bf4458f5fe1881fb360424d4d4d506fcf9b43a55bab87382f97385b0e6531aad"
    sha256 arm64_linux:   "8b05fc13b992c935779f01a0af7d8eae0157ec70b0d64ee60b9982f0fb599fc9"
    sha256 x86_64_linux:  "7e150ede33a403e0b2c4678f19efb46551f165cfce0e2c5ef097bc1a3b847d91"
  end

  depends_on "bison" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build
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
