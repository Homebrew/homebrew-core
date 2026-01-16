class Freeswitch < Formula
  desc "Telephony platform to route various communication protocols"
  homepage "https://freeswitch.org"
  license "MPL-1.1"
  head "https://github.com/signalwire/freeswitch.git", branch: "master"

  stable do
    url "https://github.com/signalwire/freeswitch.git",
        tag:      "v1.10.12",
        revision: "a88d069d6ffb74df797bcaf001f7e63181c07a09"

    # Backport support for FFmpeg 7.1
    patch do
      url "https://github.com/signalwire/freeswitch/commit/9dccd0b6e6761434d54d75d6385cdc7a7b3fa39c.patch?full_index=1"
      sha256 "b08adbb5507d655fe0f6f6b2338a724a97413eb2323b6804ae453c86be1fed84"
    end
    patch do
      url "https://github.com/signalwire/freeswitch/commit/58776f3eed03951e3a712c5124a12616f5aa735f.patch?full_index=1"
      sha256 "30248f603ff433bf1a4e1e45c3b2dd0779604bac7546c522ed77f49e2240ff7a"
    end
    patch do
      url "https://github.com/signalwire/freeswitch/commit/1fd9ac9dd1bdae6e1bd794119f8e5328fe4c7f6c.patch?full_index=1"
      sha256 "38774910ce5fd337fc6dd1ae44d6693facb8aa3f387568b870755f836c29aef9"
    end
    patch do
      url "https://github.com/signalwire/freeswitch/commit/066b92c5894b07a4879a26a9f6a1cdcf59e016ea.patch?full_index=1"
      sha256 "e3b17c6d3f8b084b981398fc913b260c7b3085c1baa6842cf702ba10b1c8b4c5"
    end

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
    rebuild 2
    sha256 arm64_tahoe:   "50b0e6ddd574d07d11602e150965e4c66aa8bd2ef057dbcab35ab9027c9e8900"
    sha256 arm64_sequoia: "2843c94ca8b99168ab789ab9bfa62717dd3d51f4a7ea402aed186b87d89b7ad5"
    sha256 arm64_sonoma:  "738a852bb829d381c482bc0507be37a6d9ffbb600b1d70568da08aded3646a25"
    sha256 sonoma:        "734e8d4c5674e749bcf7363f9e6ce31c9bde67698477199b1802a9da1146219c"
    sha256 arm64_linux:   "276be3d57380d1660c3e6aba668f82eafe58455ab0dd7a35fb07aa41168be4ec"
    sha256 x86_64_linux:  "fd32084ffc240fab77d7adfb1243e270530edf7a8778f1d2e546cd3bad2ca719"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "yasm" => :build

  depends_on "ffmpeg@7"
  depends_on "freetype"
  depends_on "jpeg-turbo"
  depends_on "ldns"
  depends_on "libpng"
  depends_on "libpq"
  depends_on "libsndfile"
  depends_on "libtiff"
  depends_on "lua"
  depends_on "opencore-amr"
  depends_on "openssl@3"
  depends_on "opus"
  depends_on "pcre2"
  depends_on "sofia-sip"
  depends_on "speex"
  depends_on "speexdsp"
  depends_on "sqlite"
  depends_on "util-linux"

  uses_from_macos "curl"
  uses_from_macos "libedit"
  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

  # https://github.com/Homebrew/homebrew/issues/42865

  #----------------------- Begin sound file resources -------------------------
  sounds_url_base = "https://files.freeswitch.org/releases/sounds"

  #---------------
  # music on hold
  #---------------
  moh_version = "1.0.52" # from build/moh_version.txt
  resource "sounds-music-8000" do
    url "#{sounds_url_base}/freeswitch-sounds-music-8000-#{moh_version}.tar.gz"
    version moh_version
    sha256 "2491dcb92a69c629b03ea070d2483908a52e2c530dd77791f49a45a4d70aaa07"
  end
  resource "sounds-music-16000" do
    url "#{sounds_url_base}/freeswitch-sounds-music-16000-#{moh_version}.tar.gz"
    version moh_version
    sha256 "93e0bf31797f4847dc19a94605c039ad4f0763616b6d819f5bddbfb6dd09718a"
  end
  resource "sounds-music-32000" do
    url "#{sounds_url_base}/freeswitch-sounds-music-32000-#{moh_version}.tar.gz"
    version moh_version
    sha256 "4129788a638b77c5f85ff35abfcd69793d8aeb9d7833a75c74ec77355b2657a9"
  end
  resource "sounds-music-48000" do
    url "#{sounds_url_base}/freeswitch-sounds-music-48000-#{moh_version}.tar.gz"
    version moh_version
    sha256 "cc31cdb5b1bd653850bf6e054d963314bcf7c1706a9bf05f5a69bcbd00858d2a"
  end

  #-----------
  # sounds-en
  #-----------
  sounds_en_version = "1.0.53" # from build/sounds_version.txt
  resource "sounds-en-us-callie-8000" do
    url "#{sounds_url_base}/freeswitch-sounds-en-us-callie-8000-#{sounds_en_version}.tar.gz"
    version sounds_en_version
    sha256 "24a2baad88696169950c84cafc236124b2bfa63114c7c8ac7d330fd980c8db05"
  end
  resource "sounds-en-us-callie-16000" do
    url "#{sounds_url_base}/freeswitch-sounds-en-us-callie-16000-#{sounds_en_version}.tar.gz"
    version sounds_en_version
    sha256 "3540235ed8ed86a3ec97d98225940f4c6bc665f917da4b3f2e1ddf99fc41cdea"
  end
  resource "sounds-en-us-callie-32000" do
    url "#{sounds_url_base}/freeswitch-sounds-en-us-callie-32000-#{sounds_en_version}.tar.gz"
    version sounds_en_version
    sha256 "6f5a572f9c3ee1a035b9b72673ffd9db57a345ce0d4fb9f85167f63ac7ec386a"
  end
  resource "sounds-en-us-callie-48000" do
    url "#{sounds_url_base}/freeswitch-sounds-en-us-callie-48000-#{sounds_en_version}.tar.gz"
    version sounds_en_version
    sha256 "980591a853fbf763818eb77132ea7e3ed876f8c4701e85070d612e1ebba09ae9"
  end

  #------------------------ End sound file resources --------------------------

  # There's no tags for now https://github.com/freeswitch/spandsp/issues/13
  resource "spandsp" do
    url "https://github.com/freeswitch/spandsp.git",
        revision: "67d2455efe02e7ff0d897f3fd5636fed4d54549e"
  end

  resource "libks" do
    url "https://github.com/signalwire/libks.git",
        tag:      "v2.0.8",
        revision: "b148f20186dfc5f168b57d2cc64c61f783801d29"
  end

  resource "signalwire-c" do
    url "https://github.com/signalwire/signalwire-c.git",
        tag:      "v2.0.0",
        revision: "c432105788424d1ddb7c59aacd49e9bfa3c5e917"
  end

  def install
    resource("spandsp").stage do
      system "./bootstrap.sh"
      system "./configure", "--disable-silent-rules", *std_configure_args(prefix: libexec/"spandsp")
      system "make"
      ENV.deparallelize { system "make", "install" }

      ENV.append_path "PKG_CONFIG_PATH", libexec/"spandsp/lib/pkgconfig"
    end

    resource("libks").stage do
      system "cmake", ".", *std_cmake_args(install_prefix: libexec/"libks")
      system "cmake", "--build", "."
      system "cmake", "--install", "."

      ENV.append_path "PKG_CONFIG_PATH", libexec/"libks/lib/pkgconfig"
      ENV.append "CFLAGS", "-I#{libexec}/libks/include"

      # Add RPATH to libks2.pc so libks2.so can be found by freeswitch modules.
      inreplace libexec/"libks/lib/pkgconfig/libks2.pc",
                "-L${libdir}",
                "-Wl,-rpath,${libdir} -L${libdir}"
    end

    resource("signalwire-c").stage do
      ENV["CMAKE_POLICY_VERSION_MINIMUM"] = "3.5"
      system "cmake", ".", *std_cmake_args(install_prefix: libexec/"signalwire-c")
      system "cmake", "--build", "."
      system "cmake", "--install", "."

      ENV.append_path "PKG_CONFIG_PATH", libexec/"signalwire-c/lib/pkgconfig"

      # Add RPATH to signalwire_client2.pc so libsignalwire_client2.so
      # can be found by freeswitch modules.
      inreplace libexec/"signalwire-c/lib/pkgconfig/signalwire_client2.pc",
                "-L${libdir}",
                "-Wl,-rpath,${libdir} -L${libdir}"
    end

    system "./bootstrap.sh", "-j"

    args = %W[
      --enable-shared
      --enable-static
      --exec_prefix=#{prefix}
    ]
    # Fails on ARM: https://github.com/signalwire/freeswitch/issues/1450
    args << "--disable-libvpx" if Hardware::CPU.arm?

    ENV.append_to_cflags "-D_ANSI_SOURCE" if OS.linux?

    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

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
