class Freeswitch < Formula
  desc "Telephony platform to route various communication protocols"
  homepage "https://freeswitch.org"
  url "https://freeswitch.org/stash/scm/fs/freeswitch.git",
      :tag => "v1.6.19",
      :revision => "7a77e0bb2ca875cb977b1e698a1783e575d96563"
  revision 2
  head "https://freeswitch.org/stash/scm/fs/freeswitch.git"

  bottle do
    sha256 "78670263f7413b56d7308f02311fd901dcbbdf7a67da92add4f93ed1b7cdb392" => :high_sierra
    sha256 "580ccaf5ac6f6d8518cec9718b5310077c436950b95d14ee5a6cdebdb9a582ca" => :sierra
    sha256 "9fcd5b9cb4606c180c2507d4cb454f95c8bb4d01d9bfce4aec1fef5b5b0f6a36" => :el_capitan
  end

  option "without-moh", "Do not install music-on-hold"
  option "without-sounds-en", "Do not install English (Callie) sounds"
  option "with-sounds-fr", "Install French (June) sounds"
  option "with-sounds-ru", "Install Russian (Elena) sounds"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "apr-util" => :build
  depends_on "yasm" => :build
  depends_on "jpeg"
  depends_on "openssl"
  depends_on "pcre"
  depends_on "sqlite"
  depends_on "lua"
  depends_on "opus"
  depends_on "libsndfile"
  depends_on "speex"
  depends_on "speexdsp"

  # https://github.com/Homebrew/homebrew/issues/42865
  fails_with :gcc

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

  #-----------
  # sounds-fr
  #-----------
  sounds_fr_version = "1.0.51" # from build/sounds_version.txt
  resource "sounds-fr-ca-june-8000" do
    url "#{sounds_url_base}/freeswitch-sounds-fr-ca-june-8000-#{sounds_fr_version}.tar.gz"
    version sounds_fr_version
    sha256 "eada67c61bd62ec420eb017df7524d10de286fba0c2da4800516b9f62c00e78c"
  end
  resource "sounds-fr-ca-june-16000" do
    url "#{sounds_url_base}/freeswitch-sounds-fr-ca-june-16000-#{sounds_fr_version}.tar.gz"
    version sounds_fr_version
    sha256 "f942980ad359951ef3f69a324a3299ef86cdb4f8d2c62adaf73a1b95fb39fcc6"
  end
  resource "sounds-fr-ca-june-32000" do
    url "#{sounds_url_base}/freeswitch-sounds-fr-ca-june-32000-#{sounds_fr_version}.tar.gz"
    version sounds_fr_version
    sha256 "8966a0c4daf666018cca6d8ba0f7708e251bed952b015d0ca6a0792341fe531b"
  end
  resource "sounds-fr-ca-june-48000" do
    url "#{sounds_url_base}/freeswitch-sounds-fr-ca-june-48000-#{sounds_fr_version}.tar.gz"
    version sounds_fr_version
    sha256 "abaea558fb5485abdd01d0b1186e03cf508f96ac90492814cc7ed4475e99a1e0"
  end

  #-----------
  # sounds-ru
  #-----------
  sounds_ru_version = "1.0.51" # from build/sounds_version.txt
  resource "sounds-ru-RU-elena-8000" do
    url "#{sounds_url_base}/freeswitch-sounds-ru-RU-elena-8000-#{sounds_ru_version}.tar.gz"
    version sounds_ru_version
    sha256 "d2679503eb1f4dc1716df5f8c4b5a7b721f087b17e96a02b1a92480311074c66"
  end
  resource "sounds-ru-RU-elena-16000" do
    url "#{sounds_url_base}/freeswitch-sounds-ru-RU-elena-16000-#{sounds_ru_version}.tar.gz"
    version sounds_ru_version
    sha256 "e5a354cd10401208291f1d0e668a8cf8215d3cdcb93f2cbd4b83dd134425e60b"
  end
  resource "sounds-ru-RU-elena-32000" do
    url "#{sounds_url_base}/freeswitch-sounds-ru-RU-elena-32000-#{sounds_ru_version}.tar.gz"
    version sounds_ru_version
    sha256 "a2b43f20246f376d55dd73d269eb238cbeb6a961a40716d2f79a5835344aabfc"
  end
  resource "sounds-ru-RU-elena-48000" do
    url "#{sounds_url_base}/freeswitch-sounds-ru-RU-elena-48000-#{sounds_ru_version}.tar.gz"
    version sounds_ru_version
    sha256 "ffd7d34907f6b6ac861e7898d2237ad763f242a17cd23811da28fd7745d3350d"
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

    if build.with?("moh")
      # Should be equivalent to: system "make", "cd-moh-install"
      mkdir_p prefix/"sounds/music"
      [8, 16, 32, 48].each do |n|
        resource("sounds-music-#{n}000").stage do
          cp_r ".", prefix/"sounds/music"
        end
      end
    end

    if build.with?("sounds-en")
      # Should be equivalent to: system "make", "cd-sounds-install"
      mkdir_p prefix/"sounds/en"
      [8, 16, 32, 48].each do |n|
        resource("sounds-en-us-callie-#{n}000").stage do
          cp_r ".", prefix/"sounds/en"
        end
      end
    end

    if build.with?("sounds-fr")
      # Should be equivalent to: system "make", "cd-sounds-fr-install"
      mkdir_p prefix/"sounds/fr"
      [8, 16, 32, 48].each do |n|
        resource("sounds-fr-ca-june-#{n}000").stage do
          cp_r ".", prefix/"sounds/fr"
        end
      end
    end

    if build.with?("sounds-ru")
      # Should be equivalent to: system "make", "cd-sounds-ru-install"
      mkdir_p prefix/"sounds/ru"
      [8, 16, 32, 48].each do |n|
        resource("sounds-ru-RU-elena-#{n}000").stage do
          cp_r ".", prefix/"sounds/ru"
        end
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
