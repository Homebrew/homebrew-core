class Freeswitch < Formula
  desc "Telephony platform to route various communication protocols"
  homepage "https://freeswitch.org"
  license "MPL-1.1"

  stable do
    # TODO: Switch to `pcre2` on next release
    url "https://github.com/signalwire/freeswitch.git",
        tag:      "v1.10.12",
        revision: "a88d069d6ffb74df797bcaf001f7e63181c07a09"

    depends_on "pcre"

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
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "2be965616dac434ef38893c57df9f86db4fb0069b05f00cf924553c9d02055a8"
    sha256 arm64_sequoia: "65ff95422df2c3a7c1841198606b083b359d41f76ae59fcca89c0e48d72161a7"
    sha256 arm64_sonoma:  "fd47ef79d42a6f6d0ad13777d79e672b021e9af8f7305da7e508b9ac06e3b602"
    sha256 arm64_ventura: "a5f39a0499abc9f2b854cc43dfd014a689d089b343fdabb9da48caa7399b9b58"
    sha256 sonoma:        "a9e87e89a6705c491da23b45e5b1982b46d1095bebc3a02a9e4804d1335b0c8a"
    sha256 ventura:       "f51506a3db00f7a54f2b45cf7f8a5899ab72cfeaef741444dc2c30ae5f32d1e5"
    sha256 arm64_linux:   "c0b4bad733698341a05e57d2576c85a96b6300b0fa1e12f6eadffaaf7beaeec4"
    sha256 x86_64_linux:  "741228a2280f5223db7851a8807e71b0101c6a7afd35c04d10541c4dc83d0e6b"
  end

  head do
    url "https://github.com/signalwire/freeswitch.git", branch: "master"

    depends_on "pcre2"
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
        tag:      "v2.0.6",
        revision: "3bc8dd0524a865becdd98c3806735eb306fe0a73"

    # Fix compile with newer Clang, https://github.com/signalwire/libks/issues/217
    patch :DATA if DevelopmentTools.clang_build_version >= 1500
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
diff --git a/cmake/ksutil.cmake b/cmake/ksutil.cmake
index a82c639..df04a70 100644
--- a/cmake/ksutil.cmake
+++ b/cmake/ksutil.cmake
@@ -103,6 +103,7 @@ macro(ksutil_setup_platform)
 		add_compile_options("$<$<CONFIG:Release>:-Wno-parentheses>")
 		add_compile_options("$<$<CONFIG:Release>:-Wno-pointer-sign>")
 		add_compile_options("$<$<CONFIG:Release>:-Wno-switch>")
+		add_compile_options("$<$<CONFIG:Release>:-Wno-int-conversion>")
 
 		add_compile_options("$<$<CONFIG:Debug>:-O0>")
 		add_compile_options("$<$<CONFIG:Debug>:-g>")
@@ -110,6 +111,7 @@ macro(ksutil_setup_platform)
 		add_compile_options("$<$<CONFIG:Debug>:-Wno-parentheses>")
 		add_compile_options("$<$<CONFIG:Debug>:-Wno-pointer-sign>")
 		add_compile_options("$<$<CONFIG:Debug>:-Wno-switch>")
+		add_compile_options("$<$<CONFIG:Debug>:-Wno-int-conversion>")
 
 		set(CMAKE_POSITION_INDEPENDENT_CODE YES)
 		add_definitions("-DKS_PLAT_MAC=1")
