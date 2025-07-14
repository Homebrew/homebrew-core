class Kea < Formula
  desc "DHCP server"
  homepage "https://www.isc.org/kea/"
  url "https://ftp.isc.org/isc/kea/3.0.0/kea-3.0.0.tar.xz"
  mirror "https://dl.cloudsmith.io/public/isc/kea-3-0/raw/versions/3.0.0/kea-3.0.0.tar.xz"
  sha256 "bf963d1e10951d8c570c6042afccf27c709d45e03813bd2639d7bb1cfc4fee76"
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
    sha256 arm64_sequoia: "f0e83d9140f20f6355907c13ff072dfe70132db802effe8d485b8cb01e1ef2d2"
    sha256 arm64_sonoma:  "bf539cf6840a30b7b4b4fec39e24e63118cabb9c0035d9c3b36929d725df22c0"
    sha256 arm64_ventura: "5ba48075f58961f427074a7b828dd18a5cf1b1c20015a009b25ac77db2c84e82"
    sha256 sonoma:        "a94f296cdd03ec1b144daf89a0d39784c690faacd60dc1d58a3adeb0ce6de845"
    sha256 ventura:       "1e0e8f7dc19a6e593793d59ff68e56efb5b7e78a7e0c4db8c43eba4bb888e820"
    sha256 arm64_linux:   "b0bc98ac3a87fd3b035560adc0b6ebaa58b329026b9887f2de464dfbc32f9800"
    sha256 x86_64_linux:  "4eda8328fcd0007696b0e3effd87578eab7b118bc058e4be7c6b2d5cda41f44a"
  end

  depends_on "bison" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build
  depends_on "boost"
  depends_on "log4cplus"
  depends_on "openssl@3"

  def install
    # the build system looks for `sudo` to run some commands, but we don't want to use it
    inreplace "meson.build",
              "SUDO = find_program('sudo', required: false)",
              "SUDO = find_program('', required: false)"

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
