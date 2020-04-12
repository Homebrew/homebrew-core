class Olsrd < Formula
  desc "Implementation of the optimized link state routing protocol"
  homepage "http://www.olsr.org"
  # olsr's website is "ill" and does not contain the latest release.
  # https://github.com/OLSR/olsrd/issues/48
  url "https://github.com/OLSR/olsrd/archive/v0.9.8.tar.gz"
  sha256 "ee9e524224e5d5304dcf61f1dc5485c569da09d382934ff85b233be3e24821a3"

  bottle do
    cellar :any_skip_relocation
    sha256 "ebde0dd319053bf4a5fff8d508b77e64648c99744784f294f488c1c75afda008" => :catalina
    sha256 "4f10d4e0d33d101369a9b216adcdc445cd8bce3ee6a1c09548578688c7dc8ac9" => :mojave
    sha256 "27524e71f30ba6e64fa5184058b6c73c4dfbfda348b2c2817258db758fcdeb99" => :high_sierra
    sha256 "1131b24ca42d043af8eb8a338337150c8ad9f10d9d71968e119779c3eae1bc93" => :sierra
    sha256 "88c836acf65237195c3b0d74a7fde0813c2008ab79c216ba8b36e789e58192ab" => :el_capitan
    sha256 "c6c165c6ae75a58c33995a7820f83604758ed37c9fb1c4d1557cad4c68b7f752" => :yosemite
    sha256 "842c328edcde3ccbffcc8dfddae63f802c716fb18aa63aea4fe620bbed5d8562" => :mavericks
  end

  depends_on "coreutils" => :build # needs GNU cp

  def install
    ENV.prepend_path "PATH", Formula["coreutils"].libexec/"gnubin"
    lib.mkpath
    args = %W[
      DESTDIR=#{prefix}
      USRDIR=#{prefix}
      LIBDIR=#{lib}
      ETCDIR=#{etc}
    ]
    system "make", "build_all", *args
    system "make", "install_all", *args
  end

  plist_options :startup => true, :manual => "olsrd -f #{HOMEBREW_PREFIX}/etc/olsrd.conf"

  def startup_plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{HOMEBREW_PREFIX}/sbin/olsrd</string>
            <string>-f</string>
            <string>#{etc}/olsrd.conf</string>
          </array>
          <key>KeepAlive</key>
          <dict>
            <key>NetworkState</key>
            <true/>
          </dict>
        </dict>
      </plist>
    EOS
  end

  test do
    assert_match version.to_s, pipe_output("#{sbin}/olsrd")
  end
end
