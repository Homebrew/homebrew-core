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
    rebuild 2
    sha256 arm64_sequoia: "6756f75f71aeb38c7756dff6e090cfee952ca87692ca890a727d1b8dca4fdd30"
    sha256 arm64_sonoma:  "c6fe0ecacc9a978798587d54d22eea826132e4400a4f9e76fc533591a526460c"
    sha256 arm64_ventura: "344967cebfddd0b82cd24c29a65b7303798b65b9d93fd6977a1e62605b200ca9"
    sha256 sonoma:        "ffdb1bc51a8dfdae5135c5c701932c600ee0b0c91424db61e6e4d713f553edfe"
    sha256 ventura:       "ed977705d46715e70a8f882f979678e774ccdb8c083b0a85988c25d41c89032f"
    sha256 x86_64_linux:  "7db8dc0961d2189f7a6ca03d96b028a1555ebda7fc69395addb98c11698d2cee"
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
  depends_on "python@3.13"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "ncurses"

  on_linux do
    depends_on "util-linux"
  end

  def python3
    "python3.13"
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
