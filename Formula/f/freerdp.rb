class Freerdp < Formula
  desc "X11 implementation of the Remote Desktop Protocol (RDP)"
  homepage "https://www.freerdp.com/"
  url "https://github.com/FreeRDP/FreeRDP/archive/refs/tags/3.2.0.tar.gz"
  sha256 "03251e25cc3c8dc688bd9276ce7dc6590058122b192e6c3a15574cb93fc83591"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_sonoma:   "09b8124496fda4bbf7ad3e2838da0ffb85af13bc89b00db4a51ba0fc59c8fa54"
    sha256                               arm64_ventura:  "086d8da3ced45839a4305af669f2129244fe6f4876dab9d51ee1db99df704d0f"
    sha256                               arm64_monterey: "212b40f435c732a2b0df6953d98b2700609bfb1410fdd625151710b1d11f773d"
    sha256                               arm64_big_sur:  "2f70e7eb0f7769365e366bc2b8d5f521605adfe6a7185e420b1935e7db3a1dee"
    sha256                               sonoma:         "d9b28c0cb94c08fe32f9051170f76d4feb52ab32afd7092906154f0bb22e62e6"
    sha256                               ventura:        "22606e33705046efc043b8e086c709498acdce02f2210b1eaf6c1afcb27cec95"
    sha256                               monterey:       "adbc165e1eb025bd9a52af75c575ce64cb39037dd9f45100677083cd83f3c791"
    sha256                               big_sur:        "522750f966e0f0d5886a34bfea642837b13b4ba40aff9dd3e9a83839a4afa2cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9aec0ffb441572dc1ed378fe30ae851bcb4e2db6c9f2df80f04ba7780c44c0b8"
  end

  head do
    url "https://github.com/FreeRDP/FreeRDP.git", branch: "master"
    depends_on xcode: :build
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "cjson"
  depends_on "ffmpeg"
  depends_on "jpeg-turbo"
  depends_on "libusb"
  depends_on "libx11"
  depends_on "libxcursor"
  depends_on "libxext"
  depends_on "libxfixes"
  depends_on "libxi"
  depends_on "libxinerama"
  depends_on "libxrandr"
  depends_on "libxrender"
  depends_on "libxv"
  depends_on "openssl@3"
  depends_on "pkcs11-helper"

  uses_from_macos "cups"

  on_linux do
    depends_on "alsa-lib"
    depends_on "glib"
    depends_on "libfuse"
    depends_on "systemd"
    depends_on "wayland"
  end

  def install
    args = %W[
      -DWITH_X11=ON
      -DBUILD_SHARED_LIBS=ON
      -DWITH_JPEG=ON
      -DCMAKE_INSTALL_NAME_DIR=#{lib}
      -DWITH_MANPAGES=OFF
      -DWITH_WEBVIEW=OFF
      -DWITH_CLIENT_SDL=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def caveats
    extra = ""
    on_macos do
      extra = <<~EOS

        XQuartz provides an XServer for macOS. The XQuartz can be installed
        as a package from www.xquartz.org or as a Homebrew cask:
          brew install --cask xquartz
      EOS
    end

    <<~EOS
      xfreerdp is an X11 application that requires an XServer be installed
      and running. Lack of a running XServer will cause a "$DISPLAY" error.
      #{extra}
    EOS
  end

  test do
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    success = `#{bin}/xfreerdp --version` # not using system as expected non-zero exit code
    details = $CHILD_STATUS
    raise "Unexpected exit code #{$CHILD_STATUS} while running xfreerdp" if !success && details.exitstatus != 128
  end
end
