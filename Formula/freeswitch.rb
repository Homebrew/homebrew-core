class Freeswitch < Formula
  desc "Telephony platform to route various communication protocols"
  homepage "https://freeswitch.org"
  url "https://github.com/signalwire/freeswitch.git",
      tag:      "v1.10.7",
      revision: "883d2cb662bed0316e157bd3beb9853e96c60d02"
  license "MPL-1.1"
  revision 5
  head "https://github.com/signalwire/freeswitch.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_monterey: "92c4fbe41ea20e17015b925bb7dacc9a1e390750d92828bdda8669512b5eb730"
    sha256 arm64_big_sur:  "b9f5274cd30763c538687ee99d8127a82b158bd6dd040f7903cfebe11cd72635"
    sha256 monterey:       "212d0a0c336d7d9664a11253a1e03346e61639c586415365747586729e049b43"
    sha256 big_sur:        "0fa34380d2de422598e412f860b8d0e203f1b7d20e88e02eb4977440cd7db3ea"
    sha256 catalina:       "c5d905de36a82f12b1c3bd923d991fac46cfd0a1eaf399fe20616e4e2ec23a0e"
    sha256 x86_64_linux:   "97d3d76aa7658d3a4c86a714721afe7905f3ce1826bc5187af214fedd498a551"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "yasm" => :build
  depends_on "ffmpeg@4"
  depends_on "jpeg-turbo"
  depends_on "ldns"
  depends_on "libpq"
  depends_on "libsndfile"
  depends_on "libtiff"
  depends_on "lua"
  depends_on "openssl@1.1"
  depends_on "opus"
  depends_on "pcre"
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
  sounds_en_version = "1.0.52" # from build/sounds_version.txt
  resource "sounds-en-us-callie-8000" do
    url "#{sounds_url_base}/freeswitch-sounds-en-us-callie-8000-#{sounds_en_version}.tar.gz"
    version sounds_en_version
    sha256 "fbe51296ba5282864a8f0269a968de0783b88b2a75dad710ee076138382a5151"
  end
  resource "sounds-en-us-callie-16000" do
    url "#{sounds_url_base}/freeswitch-sounds-en-us-callie-16000-#{sounds_en_version}.tar.gz"
    version sounds_en_version
    sha256 "bf3ac7be99939f57ed4fab7b76d1e47ba78d1573cc72aa0cfe656c559eb097bd"
  end
  resource "sounds-en-us-callie-32000" do
    url "#{sounds_url_base}/freeswitch-sounds-en-us-callie-32000-#{sounds_en_version}.tar.gz"
    version sounds_en_version
    sha256 "9091553934f7ee453646058ff54837f55c5b38be11c987148c63a1cccc88b741"
  end
  resource "sounds-en-us-callie-48000" do
    url "#{sounds_url_base}/freeswitch-sounds-en-us-callie-48000-#{sounds_en_version}.tar.gz"
    version sounds_en_version
    sha256 "9df388d855996a04f6014999d59d4191e22b579f2e8df542834451a25ea3e1cf"
  end

  #------------------------ End sound file resources --------------------------

  # There's no tags for now https://github.com/freeswitch/spandsp/issues/13
  resource "spandsp" do
    url "https://github.com/freeswitch/spandsp.git",
        revision: "284fe91dd068d0cf391139110fdc2811043972b9"
  end

  resource "libks" do
    url "https://github.com/signalwire/libks.git",
        tag:      "v1.7.0",
        revision: "db9bfa746b1fffcaf062bbe060c8cef70c227116"
  end

  resource "signalwire-c" do
    url "https://github.com/signalwire/signalwire-c.git",
        tag:      "1.3.0",
        revision: "e2f3abf59c800c6d39234e9f0a85fb15d1486d8d"
  end

  def install
    resource("spandsp").stage do
      system "./bootstrap.sh"
      system "./configure", "--disable-debug",
                            "--disable-dependency-tracking",
                            "--disable-silent-rules",
                            "--prefix=#{libexec}/spandsp"
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

      # Add RPATH to libks.pc so libks.so can be found by freeswitch modules.
      inreplace libexec/"libks/lib/pkgconfig/libks.pc",
                "-L${libdir}",
                "-Wl,-rpath,${libdir} -L${libdir}"
    end

    resource("signalwire-c").stage do
      system "cmake", ".", *std_cmake_args(install_prefix: libexec/"signalwire-c")
      system "cmake", "--build", "."
      system "cmake", "--install", "."

      ENV.append_path "PKG_CONFIG_PATH", libexec/"signalwire-c/lib/pkgconfig"

      # Add RPATH to signalwire_client.pc so libsignalwire_client.so
      # can be found by freeswitch modules.
      inreplace libexec/"signalwire-c/lib/pkgconfig/signalwire_client.pc",
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
    system "./configure", *std_configure_args, *args
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
    system "#{bin}/freeswitch", "-version"
  end
end
