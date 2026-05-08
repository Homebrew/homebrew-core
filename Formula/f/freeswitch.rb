class Freeswitch < Formula
  desc "Telephony platform to route various communication protocols"
  homepage "https://freeswitch.org"
  url "https://files.freeswitch.org/releases/freeswitch/freeswitch-1.11.0.-release.tar.gz"
  sha256 "c70448c2d08acc60a724702a1d8e991c8717c5306fd13e04145aa31600f4be6a"
  license all_of: [
    "MPL-1.1",
    "LGPL-2.1-only", # spandsp
  ]

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "40557f7d1066959f7592b8b5c25e3efd4de73dc3a4b012e00c316c51231da129"
    sha256 arm64_sequoia: "bf3d8afdf4d4e01e596acfd0d0acdc9c3c193d6715dc32f459fb3ce22acbd415"
    sha256 arm64_sonoma:  "75213dcb50ff2a1bc6a83018472433973d83cf7ca4498203f659714358c57333"
    sha256 sonoma:        "e52ef8d99c76cc07510ae351a3e1718c15982a4f8ac6091ff1853b83d6f952dc"
    sha256 arm64_linux:   "1e9e58cb30f9b1cb6ecabdd3e1bc084fd2267cdd4172d2d6462cf92746e5670b"
    sha256 x86_64_linux:  "9750340acce25c343e6f3f46107c4a9590c8c6b8c6a04884c87d789c34eaacdb"
  end

  head do
    url "https://github.com/signalwire/freeswitch.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build

  depends_on "freetype"
  depends_on "jpeg-turbo"
  depends_on "ldns"
  depends_on "libks"
  depends_on "libpng"
  depends_on "libpq"
  depends_on "libsndfile"
  depends_on "libtiff"
  depends_on "lua"
  depends_on "opencore-amr"
  depends_on "openssl@3"
  depends_on "opus"
  depends_on "pcre2"
  depends_on "signalwire-client-c"
  depends_on "sofia-sip"
  depends_on "speex"
  depends_on "speexdsp"
  depends_on "sqlite"

  uses_from_macos "curl"
  uses_from_macos "libedit"

  on_linux do
    depends_on "util-linux"
  end

  on_intel do
    depends_on "nasm" => :build
  end

  #----------------------- Begin sound file resources -------------------------
  sounds_url_base = "https://files.freeswitch.org/releases/sounds"

  #---------------
  # music on hold
  #---------------
  resource "sounds-music-8000" do
    url "#{sounds_url_base}/freeswitch-sounds-music-8000-1.0.52.tar.gz"
    version "1.0.52"
    sha256 "2491dcb92a69c629b03ea070d2483908a52e2c530dd77791f49a45a4d70aaa07"

    livecheck do
      url "https://raw.githubusercontent.com/signalwire/freeswitch/refs/tags/v#{LATEST_VERSION}/build/moh_version.txt"
      regex(/^v?(\d+(?:\.\d+)+)$/i)
    end
  end
  resource "sounds-music-16000" do
    url "#{sounds_url_base}/freeswitch-sounds-music-16000-1.0.52.tar.gz"
    version "1.0.52"
    sha256 "93e0bf31797f4847dc19a94605c039ad4f0763616b6d819f5bddbfb6dd09718a"

    livecheck do
      url "https://raw.githubusercontent.com/signalwire/freeswitch/refs/tags/v#{LATEST_VERSION}/build/moh_version.txt"
      regex(/^v?(\d+(?:\.\d+)+)$/i)
    end
  end
  resource "sounds-music-32000" do
    url "#{sounds_url_base}/freeswitch-sounds-music-32000-1.0.52.tar.gz"
    version "1.0.52"
    sha256 "4129788a638b77c5f85ff35abfcd69793d8aeb9d7833a75c74ec77355b2657a9"

    livecheck do
      url "https://raw.githubusercontent.com/signalwire/freeswitch/refs/tags/v#{LATEST_VERSION}/build/moh_version.txt"
      regex(/^v?(\d+(?:\.\d+)+)$/i)
    end
  end
  resource "sounds-music-48000" do
    url "#{sounds_url_base}/freeswitch-sounds-music-48000-1.0.52.tar.gz"
    version "1.0.52"
    sha256 "cc31cdb5b1bd653850bf6e054d963314bcf7c1706a9bf05f5a69bcbd00858d2a"

    livecheck do
      url "https://raw.githubusercontent.com/signalwire/freeswitch/refs/tags/v#{LATEST_VERSION}/build/moh_version.txt"
      regex(/^v?(\d+(?:\.\d+)+)$/i)
    end
  end

  #-----------
  # sounds-en
  #-----------
  resource "sounds-en-us-callie-8000" do
    url "#{sounds_url_base}/freeswitch-sounds-en-us-callie-8000-1.0.53.tar.gz"
    version "1.0.53"
    sha256 "24a2baad88696169950c84cafc236124b2bfa63114c7c8ac7d330fd980c8db05"

    livecheck do
      url "https://raw.githubusercontent.com/signalwire/freeswitch/refs/tags/v#{LATEST_VERSION}/build/sounds_version.txt"
      regex(/^en-us-callie v?(\d+(?:\.\d+)+)$/i)
    end
  end
  resource "sounds-en-us-callie-16000" do
    url "#{sounds_url_base}/freeswitch-sounds-en-us-callie-16000-1.0.53.tar.gz"
    version "1.0.53"
    sha256 "3540235ed8ed86a3ec97d98225940f4c6bc665f917da4b3f2e1ddf99fc41cdea"

    livecheck do
      url "https://raw.githubusercontent.com/signalwire/freeswitch/refs/tags/v#{LATEST_VERSION}/build/sounds_version.txt"
      regex(/^en-us-callie v?(\d+(?:\.\d+)+)$/i)
    end
  end
  resource "sounds-en-us-callie-32000" do
    url "#{sounds_url_base}/freeswitch-sounds-en-us-callie-32000-1.0.53.tar.gz"
    version "1.0.53"
    sha256 "6f5a572f9c3ee1a035b9b72673ffd9db57a345ce0d4fb9f85167f63ac7ec386a"

    livecheck do
      url "https://raw.githubusercontent.com/signalwire/freeswitch/refs/tags/v#{LATEST_VERSION}/build/sounds_version.txt"
      regex(/^en-us-callie v?(\d+(?:\.\d+)+)$/i)
    end
  end
  resource "sounds-en-us-callie-48000" do
    url "#{sounds_url_base}/freeswitch-sounds-en-us-callie-48000-1.0.53.tar.gz"
    version "1.0.53"
    sha256 "980591a853fbf763818eb77132ea7e3ed876f8c4701e85070d612e1ebba09ae9"

    livecheck do
      url "https://raw.githubusercontent.com/signalwire/freeswitch/refs/tags/v#{LATEST_VERSION}/build/sounds_version.txt"
      regex(/^en-us-callie v?(\d+(?:\.\d+)+)$/i)
    end
  end

  #------------------------ End sound file resources --------------------------

  # There's no tags for now https://github.com/freeswitch/spandsp/issues/13
  # Using same source tarball as upstream's `signalwire/signalwire/spandsp` formula:
  # https://github.com/signalwire/homebrew-signalwire/blob/master/Formula/spandsp.rb
  resource "spandsp" do
    url "https://files.freeswitch.org/downloads/libs/spandsp-3.0.0-0d2e6ac65e.tar.gz"
    version "3.0.0-0d2e6ac65e"
    sha256 "29c728fab504eb83aa01eb4172315c2795c8be6ef9094005f21bd1e3463f5f2f"

    livecheck do
      url "https://raw.githubusercontent.com/signalwire/homebrew-signalwire/refs/heads/master/Formula/spandsp.rb"
      regex(/url ".*?spandsp[._-]v?(\d+(?:\.\d+)+-\h+)\.t/i)
    end

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  def install
    resource("spandsp").stage do
      system "./configure", "--disable-silent-rules", *std_configure_args(prefix: libexec)
      system "make", "install"
      ENV.append_path "PKG_CONFIG_PATH", libexec/"lib/pkgconfig"
    end

    system "./bootstrap.sh", "-j" if build.head?

    # Reject FFmpeg dependency due to MPL-1.1 incompatibility with GPL
    # Ref: https://www.gnu.org/licenses/license-list.html#MPL
    # Ref: https://www.mozilla.org/en-US/MPL/1.1/FAQ/
    # Ref: https://github.com/signalwire/freeswitch/blob/master/src/mod/applications/mod_av/mod_av.c#L5
    odie "MPL-1.1 is incompatible with FFmpeg's GPL license" if deps.any? { |dep| dep.name.start_with? "ffmpeg" }
    inreplace "modules.conf", %r{^applications/mod_av$}, "#\\0"

    # Workaround for opus_parse.h using true/false which are keywords in C23
    ENV.append "CFLAGS", "-std=gnu17" if DevelopmentTools.clang_build_version >= 1700

    args = %W[
      --enable-shared
      --enable-static
      --exec_prefix=#{prefix}
    ]
    # Fails on ARM: https://github.com/signalwire/freeswitch/issues/1450
    args << "--disable-libvpx" if Hardware::CPU.arm?

    system "./configure", *args, *std_configure_args
    system "make", "all"
    system "make", "install"

    # Should be equivalent to: system "make", "cd-moh-install"
    mkdir_p pkgshare/"sounds/music"
    [8, 16, 32, 48].each do |n|
      resource("sounds-music-#{n}000").stage do
        cp_r ".", pkgshare/"sounds/music"
      end
    end

    # Should be equivalent to: system "make", "cd-sounds-install"
    mkdir_p pkgshare/"sounds/en"
    [8, 16, 32, 48].each do |n|
      resource("sounds-en-us-callie-#{n}000").stage do
        cp_r ".", pkgshare/"sounds/en"
      end
    end
  end

  service do
    run [opt_bin/"freeswitch", "-nc", "-nonat"]
    keep_alive true
  end

  test do
    system bin/"freeswitch", "-version"
  end
end
