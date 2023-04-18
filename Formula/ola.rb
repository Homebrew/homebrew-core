class Ola < Formula
  desc "Open Lighting Architecture for lighting control information"
  homepage "https://www.openlighting.org/ola/"
  url "https://github.com/OpenLightingProject/ola/releases/download/0.10.9/ola-0.10.9.tar.gz"
  sha256 "44073698c147fe641507398253c2e52ff8dc7eac8606cbf286c29f37939a4ebf"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  head "https://github.com/OpenLightingProject/ola.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "088b059188475214389d952efb6c53c52ecbf09765e7bb9a861bd45bd60c4a33"
    sha256 arm64_monterey: "dfac4651c419b77a336a1c54703d273556ce977942bd78fdc4a51e4c1d354a07"
    sha256 arm64_big_sur:  "094361072bfbc2edaf6180c1d4bc679096bfefd38562a02a301176510f6f329d"
    sha256 ventura:        "ffed4857b650f63697aae34fe23bbb11d9334b5787d1d2dbad430eae0abd639f"
    sha256 monterey:       "872aa05d050ab475bffe9f4e3f5188cc7bab102804149bc8f4edde254ca99dd3"
    sha256 big_sur:        "4a5fef50aaf6ff9ae879e748c7adc4281c5df248dabc3f9aef925286570b909f"
    sha256 x86_64_linux:   "1bfba400da5d6a62cab3685d8f99aec29794a616fb413c26a1eb4d95547db195"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "liblo"
  depends_on "libmicrohttpd"
  depends_on "libusb"
  depends_on "numpy"
  depends_on "protobuf"
  depends_on "python@3.11"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def python3
    "python3.11"
  end

  def install
    # https://github.com/Homebrew/homebrew-core/pull/123791
    # remove when the above PR is merged
    ENV.append_to_cflags "-DNDEBUG"

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
  end

  test do
    system bin/"ola_plugin_state", "-h"
    system python3, "-c", "from ola.ClientWrapper import ClientWrapper"
  end
end
