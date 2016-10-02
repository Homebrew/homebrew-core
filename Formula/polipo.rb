class Polipo < Formula
  desc "Web caching proxy"
  homepage "https://www.irif.univ-paris-diderot.fr/~jch/software/polipo/"
  url "https://www.irif.univ-paris-diderot.fr/~jch/software/files/polipo/polipo-1.1.1.tar.gz"
  sha256 "a259750793ab79c491d05fcee5a917faf7d9030fb5d15e05b3704e9c9e4ee015"

  head "git://git.wifi.pps.jussieu.fr/polipo"

  bottle do
    rebuild 1
    sha256 "d30101dd7753f59f84a8962f07772a1e18ec8007096b815c3cae117a59fbb2e0" => :sierra
    sha256 "54142753c1ad2f0bbb0b7d3acd62c12dd6f5e33f059f27432a739e01a351f1a7" => :el_capitan
    sha256 "ce6453203feafa737212242a0ea9d2faa118e5880775e115682901e59fad5891" => :yosemite
    sha256 "74930c6406c860315088f3bde52332fb3708a60f5aabeeff1497a3cbbdf10a73" => :mavericks
  end

  option "with-large-chunks", "Set chunk size to 16k (more RAM, but more performance)"

  def install
    cache_root = (var + "cache/polipo")
    cache_root.mkpath
    args = %W[PREFIX=#{prefix}
              LOCAL_ROOT=#{pkgshare}/www
              DISK_CACHE_ROOT=#{cache_root}
              MANDIR=#{man}
              INFODIR=#{info}
              PLATFORM_DEFINES=-DHAVE_IPv6]
    args << 'EXTRA_DEFINES="-DCHUNK_SIZE=16384"' if build.with? "large-chunks"

    system "make", "all", *args
    system "make", "install", *args
  end

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/polipo</string>
        </array>
        <!-- Set `ulimit -n 65536`. The default macOS limit is 256, that's
             not enough for Polipo (displays 'too many files open' errors).
             It seems like you have no reason to lower this limit
             (and unlikely will want to raise it). -->
        <key>SoftResourceLimits</key>
        <dict>
          <key>NumberOfFiles</key>
          <integer>65536</integer>
        </dict>
      </dict>
    </plist>
    EOS
  end
end
