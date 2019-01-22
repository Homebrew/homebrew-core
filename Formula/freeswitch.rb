class Freeswitch < Formula
  desc "Telephony platform to route various communication protocols"
  homepage "https://freeswitch.org"
  url "https://freeswitch.org/stash/scm/fs/freeswitch.git",
      :tag      => "v1.6.20",
      :revision => "987c9b9a2a2e389becf4f390feb9eb14c77e2371"
  head "https://freeswitch.org/stash/scm/fs/freeswitch.git"

  bottle do
    sha256 "52f44a6e3713c7c5d47f4fc6a78416c7ddddfdf69ee23e7c2caef02f1e47733e" => :mojave
    sha256 "a44ff9765d3a79e6caf363f94c144ee62139320b274f70c56000d839dec618ad" => :high_sierra
    sha256 "52aa9f65dbcff17203256154422092c74195c795f50cb10b4c7182e4dcc1361b" => :sierra
    sha256 "f2d73136027050dc82f3ce4d9e6f131f07a6cf15fba1d2b02c2012eacd1cb525" => :el_capitan
  end

  depends_on "apr-util" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "yasm" => :build
  depends_on "jpeg"
  depends_on "libsndfile"
  depends_on "lua"
  depends_on "openssl"
  depends_on "opus"
  depends_on "pcre"
  depends_on "speex"
  depends_on "speexdsp"
  depends_on "sqlite"

  # https://github.com/Homebrew/homebrew/issues/42865
  fails_with :gcc_4_2

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
  sounds_en_version = "1.0.51" # from build/sounds_version.txt
  resource "sounds-en-us-callie-8000" do
    url "#{sounds_url_base}/freeswitch-sounds-en-us-callie-8000-#{sounds_en_version}.tar.gz"
    version sounds_en_version
    sha256 "e48a63bd69e6253d294ce43a941d603b02467feb5d92ee57a536ccc5f849a4a8"
  end
  resource "sounds-en-us-callie-16000" do
    url "#{sounds_url_base}/freeswitch-sounds-en-us-callie-16000-#{sounds_en_version}.tar.gz"
    version sounds_en_version
    sha256 "324b1ab5ab754db5697963e9bf6a2f9c7aeb1463755e86bbb6dc4d6a77329da2"
  end
  resource "sounds-en-us-callie-32000" do
    url "#{sounds_url_base}/freeswitch-sounds-en-us-callie-32000-#{sounds_en_version}.tar.gz"
    version sounds_en_version
    sha256 "06fd6b8aec937556bf5303ab19a212c60daf00546d395cf269dfe324ac9c6838"
  end
  resource "sounds-en-us-callie-48000" do
    url "#{sounds_url_base}/freeswitch-sounds-en-us-callie-48000-#{sounds_en_version}.tar.gz"
    version sounds_en_version
    sha256 "cfc50f1d9b5d43cb87a9a2c0ce136c37ee85ac3b0e5be930d8dc2c913c4495aa"
  end

  #------------------------ End sound file resources --------------------------

  def install
    ENV["ac_cv_lib_lzma_lzma_code"] = "no" # prevent opportunistic linkage to xz

    # avoid a dependency on ldns to prevent OpenSSL version conflicts
    inreplace "build/modules.conf.in", "applications/mod_enum",
                                       "#applications/mod_enum"

    system "./bootstrap.sh", "-j"

    # tiff will fail to find OpenGL unless told not to use X
    inreplace "libs/tiff-4.0.2/configure.gnu", "--with-pic", "--with-pic --without-x"

    system "./configure", "--disable-dependency-tracking",
                          "--enable-shared",
                          "--enable-static",
                          "--prefix=#{prefix}",
                          "--exec_prefix=#{prefix}"

    system "make"
    system "make", "install", "all"

    # Should be equivalent to: system "make", "cd-moh-install"
    mkdir_p prefix/"sounds/music"
    [8, 16, 32, 48].each do |n|
      resource("sounds-music-#{n}000").stage do
        cp_r ".", prefix/"sounds/music"
      end
    end

    # Should be equivalent to: system "make", "cd-sounds-install"
    mkdir_p prefix/"sounds/en"
    [8, 16, 32, 48].each do |n|
      resource("sounds-en-us-callie-#{n}000").stage do
        cp_r ".", prefix/"sounds/en"
      end
    end
  end

  plist_options :manual => "freeswitch -nc --nonat"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>KeepAlive</key>
        <true/>
      <key>Label</key>
        <string>#{plist_name}</string>
      <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/freeswitch</string>
          <string>-nc</string>
          <string>-nonat</string>
        </array>
      <key>RunAtLoad</key>
        <true/>
      <key>ServiceIPC</key>
        <true/>
    </dict>
    </plist>
  EOS
  end

  test do
    system "#{bin}/freeswitch", "-version"
  end
end
