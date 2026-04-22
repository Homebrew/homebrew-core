class Freeswitch < Formula
  desc "Telephony platform to route various communication protocols"
  homepage "https://freeswitch.org"
  license all_of: [
    "MPL-1.1",
    "LGPL-2.1-only", # spandsp
  ]
  revision 1
  head "https://github.com/signalwire/freeswitch.git", branch: "master"

  stable do
    # TODO: switch to tarball on next release and make autoconf/automake/libtool HEAD-only.
    # url "https://files.freeswitch.org/releases/freeswitch/freeswitch-1.10.12.-release.tar.gz"
    url "https://github.com/signalwire/freeswitch.git",
        tag:      "v1.10.12",
        revision: "a88d069d6ffb74df797bcaf001f7e63181c07a09"

    # Backport commits to cleanly apply PCRE 2 patches
    patch do
      url "https://github.com/signalwire/freeswitch/commit/a52671333386cfbdb6490d36354f1eff3a1cd2e5.patch?full_index=1"
      sha256 "aceb5b2fb81fcad786a7982c04d7ae383dbb369fbbcd91c0a4874d506fe85afb"
    end
    patch do
      url "https://github.com/signalwire/freeswitch/commit/bd0d0db878a9a26e6ef471218b850d39eae725b5.patch?full_index=1"
      sha256 "861939d709b0364b8147dff2add1543df03b4e2d0745019bfbe331644e40e8b8"
    end
    patch do
      url "https://github.com/signalwire/freeswitch/commit/12b47fe7f91b93ba9cec90676e62c6239a097c98.patch?full_index=1"
      sha256 "25e34c76deec2b38c77327040766c95c725e142958bd8c1024e9307e3fd3b326"
    end
    patch do
      url "https://github.com/signalwire/freeswitch/commit/68e587d7cf9f8df5b0c748f94185a00ad2a37238.patch?full_index=1"
      sha256 "125406e097b1ab9b904d6863819cd632f82bacffc88d8b4a6868c2984ab229ca"
    end
    patch :DATA # https://github.com/signalwire/freeswitch/commit/3a53566eab5793c8c2daf9e44e10d8a4a572aa69

    # Backport support for PCRE 2
    patch do
      url "https://github.com/signalwire/freeswitch/commit/65bc7c14bf1a9c3e61cbb0e5a611d2014b5b09b9.patch?full_index=1"
      sha256 "1b9d44620218028649793afd4a3036a557bd51cf0c7c85ca0085a26f55c53d58"
    end
    patch do
      url "https://github.com/signalwire/freeswitch/commit/909247067bd55a08db84bad2a00960bf822f1141.patch?full_index=1"
      sha256 "9a5231f273328c7676605057f7fd5fe4c922f94b40553104c2909ada64fb1861"
    end
    patch do
      url "https://github.com/signalwire/freeswitch/commit/02549c10d9155d0f71f36289aeeddc9c73a4d46e.patch?full_index=1"
      sha256 "db74f0803c3f8433a50e9811671440608d7bcbe82d0a67a4bac9bc7ad7215f19"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "dbe41c75c4ea16c17ed06e5b094a87e69a801f12f67a7853f98ee50d1a824177"
    sha256 arm64_sequoia: "58afea1ef8ed85e8e06264c8260eb490602d3cebde03c387bb7e8e25855efc34"
    sha256 arm64_sonoma:  "23a404455d18103d8a2da672ed643519d127fc5b418d653ea65054db2510d035"
    sha256 sonoma:        "0e74f3ce5b5be3d5ce024f848aee37d6e4bf94833689d842d87556e143965147"
    sha256 arm64_linux:   "3d635f86566919d6e15c8b3b093dafe70d02811ec71644519baa5517ec4c6fe5"
    sha256 x86_64_linux:  "e843725905d5d62c6a8e8633ba0119ec01a0997d58865e1ab0578e23fbd5f59d"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
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

    system "./bootstrap.sh", "-j" # TODO: if build.head?

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

__END__
diff --git a/build/Makefile.centos6 b/build/Makefile.centos6
index 327c2e6454c..24b4ac39a63 100644
--- a/build/Makefile.centos6
+++ b/build/Makefile.centos6
@@ -6,8 +6,8 @@
 # in that same directory.
 #
 #
-RPMS=git gcc-c++ autoconf automake libtool wget python ncurses-devel zlib-devel libjpeg-devel openssl-devel e2fsprogs-devel sqlite-devel libcurl-devel pcre-devel speex-devel ldns-devel libedit-devel
-DEBS=git build-essential automake autoconf 'libtool-bin|libtool' wget python uuid-dev zlib1g-dev 'libjpeg8-dev|libjpeg62-turbo-dev' libncurses5-dev libssl-dev libpcre3-dev libcurl4-openssl-dev libldns-dev libedit-dev libspeexdsp-dev  libspeexdsp-dev libsqlite3-dev perl libgdbm-dev libdb-dev bison libvlc-dev pkg-config
+RPMS=git gcc-c++ autoconf automake libtool wget ncurses-devel zlib-devel libjpeg-devel openssl-devel e2fsprogs-devel sqlite-devel libcurl-devel pcre-devel speex-devel ldns-devel libedit-devel
+DEBS=git build-essential automake autoconf 'libtool-bin|libtool' wget uuid-dev zlib1g-dev 'libjpeg8-dev|libjpeg62-turbo-dev' libncurses5-dev libssl-dev libpcre3-dev libcurl4-openssl-dev libldns-dev libedit-dev libspeexdsp-dev  libspeexdsp-dev libsqlite3-dev perl libgdbm-dev libdb-dev bison libvlc-dev pkg-config
 
 freeswitch: deps has-git freeswitch.git/Makefile
 	cd freeswitch.git && make
