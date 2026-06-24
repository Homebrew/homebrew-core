class Kea < Formula
  desc "DHCP server"
  homepage "https://www.isc.org/kea/"
  # NOTE: the livecheck block is a best guess at excluding development versions.
  #       Check https://www.isc.org/download/#Kea to make sure we're using a stable version.
  url "https://ftp.isc.org/isc/kea/3.2.0/kea-3.2.0.tar.xz"
  mirror "https://dl.cloudsmith.io/public/isc/kea-3-0/raw/versions/3.2.0/kea-3.2.0.tar.xz"
  sha256 "14bf695d37b65b9b1bf550fea5d0adaf9806c50e5419ef2a176a4b8e9aade3df"
  license "MPL-2.0"
  head "https://gitlab.isc.org/isc-projects/kea.git", branch: "master"

  livecheck do
    url "https://ftp.isc.org/isc/kea/"
    regex(%r{href=["']?v?(\d+\.\d*[02468](?:\.\d+)*)/?["' >]}i)
  end

  bottle do
    sha256 arm64_tahoe:   "e2616fdac3a762ea31b5aad89dc8ffc37d1a07213f997a06640e74ffe88206c2"
    sha256 arm64_sequoia: "27a1747ac088eaeb7f7e68e9e6d086d8a98e027ebffc8b0e24c8f9d86ea5229a"
    sha256 arm64_sonoma:  "5f5750c0f2dd70ac2bd59a89ccb356f74a4586c57706c9a6509c84a527c8a48b"
    sha256 sonoma:        "954f32a83cd8a74c1b5acc96440189515d09b3239c5c9ae191359d8113d42dee"
    sha256 arm64_linux:   "a42d71cf3f752ad26fc092a88625dbc24ee5f18c71acb90cd18c740d074a1871"
    sha256 x86_64_linux:  "29fd5531b507e07fdf3b4fb63229b64aa5eda4983a5dafd0ef34d6f71bdf0424"
  end

  depends_on "bison" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build
  depends_on "boost"
  depends_on "log4cplus"
  depends_on "openssl@3"

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
