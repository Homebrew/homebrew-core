class Netdata < Formula
  desc "Diagnose infrastructure problems with metrics, visualizations & alarms"
  homepage "https://netdata.cloud/"
  url "https://github.com/netdata/netdata/releases/download/v1.26.0/netdata-v1.26.0.tar.gz"
  sha256 "33af27eb57f954e50059a32bec624815aa742fe03182845b1d9b577f1e20e30a"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 "e7e259b56d6ea0c105fdd4615fc145adb8afc425632d2265629bca33b7326f8e" => :catalina
    sha256 "f87dd60958a01b747c07c57678e9451b913f8445ce48b4742ec800d1599b6e75" => :mojave
    sha256 "0fa96dbd7bfbba64435fab9b084136731fb1f16807f4788cd7b90591d2081298" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "json-c"
  depends_on "libuv"
  depends_on "lz4"
  depends_on "openssl@1.1"

  resource "judy" do
    url "https://downloads.sourceforge.net/project/judy/judy/Judy-1.0.5/Judy-1.0.5.tar.gz"
    sha256 "d2704089f85fdb6f2cd7e77be21170ced4b4375c03ef1ad4cf1075bd414a63eb"
  end

  def install
    # We build judy as static library, so we don't need to install it
    # into the real prefix
    judyprefix = "#{buildpath}/resources/judy"

    resource("judy").stage do
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
          "--disable-shared", "--prefix=#{judyprefix}"

      # Parallel build is broken
      ENV.deparallelize do
        system "make", "-j1", "install"
      end
    end

    ENV["PREFIX"] = prefix
    ENV.append "CFLAGS", "-I#{judyprefix}/include"
    ENV.append "LDFLAGS", "-L#{judyprefix}/lib"

    system "autoreconf", "-ivf"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          "--libexecdir=#{libexec}",
                          "--with-math",
                          "--with-zlib",
                          "--enable-dbengine",
                          "--with-user=netdata",
                          "UUID_CFLAGS=-I/usr/include",
                          "UUID_LIBS=-lc"
    system "make", "clean"
    system "make", "install"

    (etc/"netdata").install "system/netdata.conf"
  end

  def post_install
    config = etc/"netdata/netdata.conf"
    inreplace config do |s|
      s.gsub!(/web files owner = .*/, "web files owner = #{ENV["USER"]}")
      s.gsub!(/web files group = .*/, "web files group = #{Etc.getgrgid(prefix.stat.gid).name}")
    end
    (var/"cache/netdata/unittest-dbengine/dbengine").mkpath
    (var/"lib/netdata/registry").mkpath
    (var/"log/netdata").mkpath
    (var/"netdata").mkpath
  end

  plist_options manual: "#{HOMEBREW_PREFIX}/sbin/netdata -D"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>RunAtLoad</key>
          <true/>
          <key>ProgramArguments</key>
          <array>
              <string>#{opt_sbin}/netdata</string>
              <string>-D</string>
          </array>
          <key>WorkingDirectory</key>
          <string>#{var}</string>
        </dict>
      </plist>
    EOS
  end

  test do
    system "#{sbin}/netdata", "-W", "set", "registry", "netdata unique id file",
                              "#{testpath}/netdata.unittest.unique.id",
                              "-W", "set", "registry", "netdata management api key file",
                              "#{testpath}/netdata.api.key"
  end
end
