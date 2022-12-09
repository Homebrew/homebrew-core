class Ola < Formula
  desc "Open Lighting Architecture for lighting control information"
  homepage "https://www.openlighting.org/ola/"
  url "https://github.com/OpenLightingProject/ola/releases/download/0.10.8/ola-0.10.8.tar.gz"
  sha256 "102aa3114562a2a71dbf7f77d2a0fb9fc47acc35d6248a70b6e831365ca71b13"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 6
  head "https://github.com/OpenLightingProject/ola.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "0fc506d1828c3e9ceb212a4ffb1d2ec8fba994aea2f6a578e1674d72736d39cd"
    sha256 arm64_monterey: "60c048cccd4ebd8ea4d4747864424561fde0708026aa5e0e8d418a26756ae6a5"
    sha256 arm64_big_sur:  "b4892a404b054142391d3949dfad2009ea4c3c07f670239b8a7a3cebf456dbf1"
    sha256 ventura:        "39814e9bef8ba5dfb9981f64dc4529938a5c377434d1cffa29f5f47a83743331"
    sha256 monterey:       "e86204858bb4fc6b097db78514c723fd34f432b59090b8cf1c4e0c7cbda079a0"
    sha256 big_sur:        "1ffc9057fa846b557507621939543768793a5c3f4850dc4b4a612672e1372a49"
    sha256 catalina:       "fc83c54e3302d51790912defd47144844a427b67d60534a656a6bd237c6dd6bb"
    sha256 x86_64_linux:   "dbc0bd423285eeb34b808d9fd9498e8f905b3f07d3734a5d4737462b72202b9a"
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

  # remove in version 0.10.9
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/add0354bf13253a4cc89e151438a630314df0efa/ola/protobuf3.diff"
    sha256 "e06ffef1610c3b09807212d113138dae8bdc7fc8400843c25c396fa486594ebf"
  end

  def python3
    "python3.11"
  end

  def install
    # https://github.com/protocolbuffers/protobuf/issues/9947
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
    system bin/"olad", "--help"
    system bin/"ola_plugin_state", "-h"
    system python3, "-c", "from ola.ClientWrapper import ClientWrapper"
  end
end
