class Libusbmuxd < Formula
  desc "USB multiplexor library for iOS devices"
  homepage "https://www.libimobiledevice.org/"
  url "https://github.com/libimobiledevice/libusbmuxd/archive/2.0.2.tar.gz"
  sha256 "8ae3e1d9340177f8f3a785be276435869363de79f491d05d8a84a59efc8a8fdc"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "e848f6a20ddc26a91c1ebda1dff8ece2c6c6d71022a51da544abda45ec615294"
    sha256 cellar: :any,                 arm64_ventura:  "8daeedc6fe669ea9d0c280b71a526efbbc1bf3d80c9e1e8ead46bc394352e9fa"
    sha256 cellar: :any,                 arm64_monterey: "e68d2747423a57105c409b4c92a67b1e02b9c642575dda7581aef4e9b84b6aef"
    sha256 cellar: :any,                 arm64_big_sur:  "5fef7d254d513cc34f801f4b6620b81d2076410f3a0cdfce3fb4fdaf921f2151"
    sha256 cellar: :any,                 sonoma:         "2d93ac0a733d95223ceb88268706609a5fe90bf99f0e6f6ed245e0f41fbb5886"
    sha256 cellar: :any,                 ventura:        "1b2ea973bb4ffc7b5291ae569abb679fe9d6e85edabdb88296fbb67155ae11c1"
    sha256 cellar: :any,                 monterey:       "78752ec98ea7d3bc16aca3fe21b805bd5a384bc33ffc10733c68aa6d484599f4"
    sha256 cellar: :any,                 big_sur:        "fad9115e1a2d774714aecf01a93f1e732430d94d49656549169e42f5b96b1c2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c079d3ad24bfda0f8bfdcc912f52f2fbcba4576d36dcf4337d7febb68c49307a"
  end

  # libimobiledevice-glue is required for building future versions
  # Move outside of HEAD clause when there's a new release.
  head do
    url "https://github.com/libimobiledevice/libusbmuxd.git", branch: "master"
    depends_on "libimobiledevice-glue"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libplist"

  uses_from_macos "netcat" => :test

  def install
    system "./autogen.sh", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    source = free_port
    dest = free_port
    fork do
      exec bin/"iproxy", "-s", "localhost", "#{source}:#{dest}"
    end

    sleep(2)
    system "nc", "-z", "localhost", source
  end
end
