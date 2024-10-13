class Ola < Formula
  include Language::Python::Shebang

  desc "Open Lighting Architecture for lighting control information"
  homepage "https://www.openlighting.org/ola/"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 1
  head "https://github.com/OpenLightingProject/ola.git", branch: "master"

  stable do
    # TODO: Check if we can use unversioned `protobuf` at version bump
    url "https://github.com/OpenLightingProject/ola/releases/download/0.10.9/ola-0.10.9.tar.gz"
    sha256 "44073698c147fe641507398253c2e52ff8dc7eac8606cbf286c29f37939a4ebf"

    # fix liblo 0.32 header compatibility
    # upstream pr ref, https://github.com/OpenLightingProject/ola/pull/1954
    patch do
      url "https://github.com/OpenLightingProject/ola/commit/e083653d2d18018fe6ef42f757bc06462de87f28.patch?full_index=1"
      sha256 "1276aded269497fab2e3fc95653b5b8203308a54c40fe2dcd2215a7f0d0369de"
    end
  end

  bottle do
    rebuild 1
    sha256 arm64_sequoia:  "71b88c9460210835e0adc7cc3c358f089f7a103d458e9be87962c6adaf746877"
    sha256 arm64_sonoma:   "9388c8bba01773aa91a9685a1cb4fc82e0a80dacf4f0414f5cc2a90db5302579"
    sha256 arm64_ventura:  "18f42878d05f104a389e40f8fe4999286fed25cbf1075bfec19f68b6719b61bc"
    sha256 arm64_monterey: "bed04ab8e79d59830d5ea03e2e3d66e64f3948d0f9b42374b6cf5cd046c81ebe"
    sha256 sonoma:         "64c933089f105c2968b38431ff11a8b5468052edbe971546057228cf0f888987"
    sha256 ventura:        "f8af0e213940d61c3f5e81d1d37eed7baf0315f3f07bb3b514558ee131a6dc99"
    sha256 monterey:       "e04546c5b1d70e22ed87ff3a836a189837ea83c9febcaf53e5911471d7f3e7ad"
    sha256 x86_64_linux:   "447d2768a8f7c86c6adb3aa30f08dcfc2b3b7f834a325e0d0d132cdeccdc7e94"
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
  depends_on "python@3.12"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "ncurses"

  on_linux do
    depends_on "util-linux"
  end

  def python3
    "python3.12"
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
