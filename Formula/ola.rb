class Ola < Formula
  include Language::Python::Shebang

  desc "Open Lighting Architecture for lighting control information"
  homepage "https://www.openlighting.org/ola/"
  # TODO: Check if we can use unversioned `protobuf` at version bump
  url "https://github.com/OpenLightingProject/ola/releases/download/0.10.9/ola-0.10.9.tar.gz"
  sha256 "44073698c147fe641507398253c2e52ff8dc7eac8606cbf286c29f37939a4ebf"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 1
  head "https://github.com/OpenLightingProject/ola.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "70bc041b7b093dad97457e7384ab334b35d2cfebe15f6f51616493a93f83a246"
    sha256 arm64_monterey: "e98135ba113896d907f982ceec5c7d5329f7daa5e095ca488dbd951c5b0334a6"
    sha256 arm64_big_sur:  "6436e1d0108fee7e8771adbfc66a3780c3b02cd087f09c4631a43c2e8492ab12"
    sha256 ventura:        "48c24b257ef8381f901a81817e4a757aea056371b48f92ca4af5edf037a6ca29"
    sha256 monterey:       "9199cced2f2c365923d088d367d47828bf3abb839825b42c5f1bc17651b1a1e4"
    sha256 big_sur:        "133412d65cfe02c454d4a7c172af8c7dd5a0f31c1b62d26705c8063a8c4acc7c"
    sha256 x86_64_linux:   "339101088570b59af916d7586451a29b82bc443f42ea694249558b38a135f3ba"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "liblo"
  depends_on "libmicrohttpd"
  depends_on "libusb"
  depends_on "numpy"
  depends_on "protobuf@21"
  depends_on "python@3.11"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def python3
    "python3.11"
  end

  # Remove when we use unversioned protobuf
  def extra_python_path
    Formula["protobuf@21"].opt_prefix/Language::Python.site_packages(python3)
  end

  def install
    # https://github.com/Homebrew/homebrew-core/pull/123791
    # remove when the above PR is merged
    ENV.append_to_cflags "-DNDEBUG"

    # protobuf@21 is keg-only.
    # Remove when we use unversioned protobuf
    ENV.prepend_path "PYTHONPATH", extra_python_path

    args = %W[
      --disable-fatal-warnings
      --disable-silent-rules
      --disable-unittests
      --enable-python-libs
      --enable-rdm-tests
      --with-python_prefix=#{prefix}
      --with-python_exec_prefix=#{prefix}
    ]

    ENV["PYTHON"] = python3
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args, *args
    system "make", "install"

    rewrite_shebang detected_python_shebang, *bin.children
  end

  # Remove when we use unversioned protobuf
  def caveats
    <<~EOS
      To use the bundled Python libraries:
        export PYTHONPATH=#{extra_python_path}
    EOS
  end

  test do
    # `protobuf@21` is keg-only.
    # Remove when we use unversioned protobuf
    ENV.prepend_path "PYTHONPATH", extra_python_path
    system bin/"ola_plugin_state", "-h"
    system python3, "-c", "from ola.ClientWrapper import ClientWrapper"
  end
end
