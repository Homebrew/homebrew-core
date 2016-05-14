class Arangodb < Formula
  desc "Universal open-source database with a flexible data model"
  homepage "https://www.arangodb.com/"
  url "https://www.arangodb.com/repositories/Source/ArangoDB-2.8.7.tar.gz"
  sha256 "cda284af7e1d45c2250dcb2acd253e805e9aaad3504f1d09cfcb8afa5ad87020"

  head "https://github.com/arangodb/arangodb.git", :branch => "unstable"

  bottle do
    sha256 "b048abb7d6c7ed967885375341dc141512cd498ec004c823f21979a9b9e96315" => :el_capitan
    sha256 "e55fc36e8e167732f2160b1366edcee901fe380ad9deef92d963c2eb745f69c7" => :yosemite
    sha256 "b3b0b09665fef2cc8dabfacd15110e8f1d72680aeeffa6e1dc72ab3cc2fa5376" => :mavericks
  end

  depends_on "go" => :build
  depends_on "openssl"

  needs :cxx11

  fails_with :clang do
    build 600
    cause "Fails with compile errors"
  end

  def install
    # clang on 10.8 will still try to build against libstdc++,
    # which fails because it doesn't have the C++0x features
    # arangodb requires.
    ENV.libcxx

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-relative
      --datadir=#{share}
      --localstatedir=#{var}
    ]

    args << "--program-suffix=-unstable" if build.head?

    if ENV.compiler != :clang
      ENV.append "LDFLAGS", "-static-libgcc -static-libstdc++"
    end

    system "./configure", *args
    system "make", "install"
  end

  def post_install
    (var/"arangodb").mkpath
    (var/"log/arangodb").mkpath

    system "#{sbin}/arangod" + (build.head? ? "-unstable" : ""), "--upgrade", "--log.file", "-"
  end

  def caveats; <<-EOS.undent
    Please note that clang and/or its standard library 7.0.0 has a severe
    performance issue. Please consider using '--cc=gcc-5' when installing
    if you are running on such a system.
    EOS
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/opt/arangodb/sbin/arangod" + (build.head? ? "-unstable" : "") + " --log.file -"

  def plist; <<-EOS.undent
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
          <string>#{opt_sbin}/arangod</string>
          <string>-c</string>
          <string>#{etc}/arangodb/arangod.conf</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
      </dict>
    </plist>
    EOS
  end
end
