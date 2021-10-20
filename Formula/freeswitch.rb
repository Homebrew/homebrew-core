class Freeswitch < Formula
  desc "Telephony platform to route various communication protocols"
  homepage "https://freeswitch.org"
  license "MPL-1.1"
  revision 4
  head "https://github.com/signalwire/freeswitch.git"

  stable do
    url "https://github.com/signalwire/freeswitch.git",
        tag:      "v1.10.5",
        revision: "25569c16311afb3fe04a445830a8ab5c88488a5e"

    # Fix find_if_index
    # see https://github.com/signalwire/freeswitch/issues/859 and https://github.com/signalwire/freeswitch/pull/863
    #
    # remove this in next release
    patch do
      url "https://github.com/signalwire/freeswitch/commit/611377d40b560402f21ec5bd5a23f32ef09c9d1d.patch?full_index=1"
      sha256 "95323626a7720e16e3f35e2889d5925fdc6c2c2efbe37f6fe5ab6e8733e3ae4d"
    end

    # Fix mod_spandsp
    # see https://github.com/signalwire/freeswitch/pull/812
    #
    # remove this in next release
    patch do
      url "https://github.com/signalwire/freeswitch/commit/61368b24c16d7f9509fe7f5b1895d8404e23cd50.patch?full_index=1"
      sha256 "f03fe3f8ae993af045ee7910c6a7446f84c29f8bea936ab4c0f700344f3d5afb"
    end

    # Fix mod_gsmopen
    # see https://github.com/signalwire/freeswitch/pull/812
    #
    # remove this in next release
    patch do
      url "https://github.com/signalwire/freeswitch/commit/51fba83ed3ed2d9753d8e6b13e13001aca50b493.patch?full_index=1"
      sha256 "1c5332127af09cddd3cba3b71d02de5deb025d552cc93b1f383874d89566956e"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_big_sur: "35b3037b7963136bb45b8b520869a78c25a6cf5720f4662e8f0abe48f6f126c6"
    sha256 big_sur:       "8c0b4e5a7b39262a5e49d4cd292037a7b609fb3eb37cb7429107f36d73aa4a11"
    sha256 catalina:      "8e5b55e233f7fa78e69debec11374f9d548abf215b4f6e4ee470a975a0caa74b"
    sha256 mojave:        "148bdaee852aef6d3183d7be15a78b52776b0159db7e65c074065df20d62a7bd"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "yasm" => :build
  depends_on "ffmpeg"
  depends_on "jpeg"
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

  uses_from_macos "libedit"
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
        revision: "6351b1824a7634853bf963c0ec399e783e35d4d1"
  end

  resource "libks" do
    url "https://github.com/signalwire/libks.git",
        tag:      "1.6.0",
        revision: "637e0e3db192a6d73a248cf0e794a4b03424805b"
  end

  resource "signalwire-c" do
    url "https://github.com/signalwire/signalwire-c.git",
        tag:      "1.3.0",
        revision: "e2f3abf59c800c6d39234e9f0a85fb15d1486d8d"
  end

  def install
    # Fix build error "use of undeclared identifier 'NSIG'"
    # Remove when fixed upstream: https://github.com/signalwire/freeswitch/issues/1145
    ENV.append_to_cflags "-D_DARWIN_C_SOURCE" if OS.mac?

    resource("spandsp").stage do
      system "./bootstrap.sh"
      system "./configure", "--disable-debug",
                            "--disable-dependency-tracking",
                            "--disable-silent-rules",
                            "--prefix=#{libexec}/spandsp"
      system "make"
      ENV.deparallelize { system "make", "install" }

      ENV.append_path "PKG_CONFIG_PATH", "#{libexec}/spandsp/lib/pkgconfig"
    end

    resource("libks").stage do
      system "cmake", ".", *std_cmake_args, "-DCMAKE_INSTALL_PREFIX=#{libexec}/libks"
      system "make", "install"

      ENV.append_path "PKG_CONFIG_PATH", "#{libexec}/libks/lib/pkgconfig"
      ENV.append "CFLAGS", "-I#{libexec}/libks/include"
    end

    resource("signalwire-c").stage do
      system "cmake", ".", *std_cmake_args, "-DCMAKE_INSTALL_PREFIX=#{libexec}/signalwire-c"
      system "make", "install"

      ENV.append_path "PKG_CONFIG_PATH", "#{libexec}/signalwire-c/lib/pkgconfig"
    end

    system "./bootstrap.sh", "-j"

    system "./configure", "--disable-dependency-tracking",
                          "--enable-shared",
                          "--enable-static",
                          "--prefix=#{prefix}",
                          "--exec_prefix=#{prefix}"

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
