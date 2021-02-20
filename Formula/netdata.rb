class Netdata < Formula
  desc "Diagnose infrastructure problems with metrics, visualizations & alarms"
  homepage "https://netdata.cloud/"
  url "https://github.com/netdata/netdata/releases/download/v1.29.2/netdata-v1.29.2.tar.gz"
  sha256 "3419a2b54cd29946900e88fa96f8235b6db50bafa615a35c0035887e8a3f5074"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_big_sur: "e4ddf468094289a4b581732c2419665015381ac431fe80529e53830e2de34d39"
    sha256 big_sur:       "c508ffce0402e951e06d6f8c2ef8dbd4a4daaced82387e2324e6f619cd9ecd04"
    sha256 catalina:      "b43fa3061723877eeffbd43c79651e09639a7c777629ac6af71ea655fbc69e40"
    sha256 mojave:        "7e96baa8ac386ca7fc1eaa42a52f04646b1ccfe0da315d1c9b2e9268ed48fb9f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "json-c"
  depends_on "libuv"
  depends_on "lz4"
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  on_linux do
    depends_on "util-linux"
  end

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
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --libexecdir=#{libexec}
      --with-math
      --with-zlib
      --enable-dbengine
      --with-user=netdata
    ]
    on_macos do
      args << "UUID_LIBS=-lc"
      args << "UUID_CFLAGS=-I/usr/include"
    end
    on_linux do
      args << "UUID_LIBS=-luuid"
      args << "UUID_CFLAGS=-I#{Formula["util-linux"].opt_include}"
    end
    system "./configure", *args
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
